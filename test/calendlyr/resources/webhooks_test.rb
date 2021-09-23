# frozen_string_literal: true

require "test_helper"

class WebhooksResourceTest < Minitest::Test
  def test_list
    organization_uri = "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA"
    scope = "user"
    response = {body: fixture_file("webhooks/list"), status: 200}
    stub(path: "webhook_subscriptions?organization=#{organization_uri}&scope=#{scope}", response: response)
    webhooks = client.webhooks.list(organization_uri: organization_uri, scope: scope)

    assert_equal Calendlyr::Collection, webhooks.class
    assert_equal Calendlyr::Webhook, webhooks.data.first.class
    assert_equal 1, webhooks.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", webhooks.next_page_token
  end

  def test_create
    body = {url: "https://blah.foo/bar", events: ["invitee.created"], organization: "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA", scope: "user", user: "https://api.calendly.com/users/AAAAAAAAAAAAAAAA"}
    stub(method: :post, path: "webhook_subscriptions", body: body, response: {body: fixture_file("webhooks/create"), status: 201})

    assert client.webhooks.create(url: body[:url], events: body[:events], organization_uri: body[:organization], scope: body[:scope], user_uri: body[:user])
  end

  def test_retrieve
    webhook_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("webhooks/retrieve"), status: 200}
    stub(path: "webhook_subscriptions/#{webhook_uuid}", response: response)
    webhook = client.webhooks.retrieve(webhook_uuid: webhook_uuid)

    assert_equal Calendlyr::Webhook, webhook.class
    assert_equal "user", webhook.scope
  end

  def test_delete
    webhook_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("webhooks/delete")}
    stub(method: :delete, path: "webhook_subscriptions/#{webhook_uuid}", response: response)
    assert client.webhooks.delete(webhook_uuid: webhook_uuid)
  end
end
