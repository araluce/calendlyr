# frozen_string_literal: true

require "test_helper"

class WebhooksResourceTest < Minitest::Test
  def test_list
    organization_uri = "https://api.calendly.com/organizations/abc123"
    scope = "user"
    response = {body: fixture_file("webhooks/list"), status: 200}
    stub(path: "webhook_subscriptions?organization=#{organization_uri}&scope=#{scope}", response: response)
    webhooks = client.webhooks.list(organization: organization_uri, scope: scope)

    assert_equal Calendlyr::Collection, webhooks.class
    assert_equal Calendlyr::Webhooks::Subscription, webhooks.data.first.class
    assert_equal 1, webhooks.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", webhooks.next_page_token
  end

  def test_create
    body = {url: "https://blah.foo/bar", events: ["invitee.created"], organization: "https://api.calendly.com/organizations/abc123", scope: "user", user: "https://api.calendly.com/users/abc123"}
    stub(method: :post, path: "webhook_subscriptions", body: body, response: {body: fixture_file("webhooks/create"), status: 201})

    assert client.webhooks.create(**body)
    assert client.organization.create_webhook(**body)
  end

  def test_retrieve
    webhook_uuid = "abc123"
    stub(path: "webhook_subscriptions/#{webhook_uuid}", response: {body: fixture_file("webhooks/retrieve"), status: 200})
    stub(path: "users/abc123", response: {body: fixture_file("users/retrieve"), status: 200})
    webhook = client.webhooks.retrieve(webhook_uuid: webhook_uuid)

    assert_equal Calendlyr::Webhooks::Subscription, webhook.class
    assert_equal "user", webhook.scope
    assert_equal webhook.associated_user, client.users.retrieve(uuid: "abc123")
    assert_equal webhook.associated_organization, client.users.retrieve(uuid: "abc123").organization
    assert_equal webhook.active?, true
  end

  def test_list_with_bare_org_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    scope = "organization"
    response = {body: fixture_file("webhooks/list"), status: 200}
    stub(path: "webhook_subscriptions?organization=#{expanded}&scope=#{scope}", response: response)

    webhooks = client.webhooks.list(organization: bare_uuid, scope: scope)

    assert_equal Calendlyr::Collection, webhooks.class
    assert_equal 1, webhooks.data.count
  end

  def test_create_with_bare_org_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    body = {url: "https://blah.foo/bar", events: ["invitee.created"], organization: expanded, scope: "user", user: "https://api.calendly.com/users/abc123"}
    stub(method: :post, path: "webhook_subscriptions", body: body, response: {body: fixture_file("webhooks/create"), status: 201})

    result = client.webhooks.create(url: "https://blah.foo/bar", events: ["invitee.created"], organization: bare_uuid, scope: "user", user: "https://api.calendly.com/users/abc123")

    assert result
  end

  def test_delete
    webhook_uuid = "abc123"
    response = {body: fixture_file("webhooks/delete")}
    stub(method: :delete, path: "webhook_subscriptions/#{webhook_uuid}", response: response)
    assert client.webhooks.delete(webhook_uuid: webhook_uuid)
  end

  def test_list_all_returns_all_pages
    organization_uri = "https://api.calendly.com/organizations/abc123"
    scope = "user"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("webhooks/list"), status: 200}
    page2_response = {body: fixture_file("webhooks/list_page2"), status: 200}
    stub(path: "webhook_subscriptions?organization=#{organization_uri}&scope=#{scope}", response: page1_response)
    stub(path: "webhook_subscriptions?organization=#{organization_uri}&scope=#{scope}&page_token=#{token}", response: page2_response)

    webhooks = client.webhooks.list_all(organization: organization_uri, scope: scope)

    assert_equal Array, webhooks.class
    assert_equal 2, webhooks.size
    assert_equal Calendlyr::Webhooks::Subscription, webhooks.first.class
  end

  def test_sample
    organization_uri = "https://api.calendly.com/organizations/abc123"
    event = "invitee.created"
    scope = "organization"
    stub(path: "sample_webhook_data?event=#{event}&organization=#{organization_uri}&scope=#{scope}", response: {body: fixture_file("webhooks/sample"), status: 200})

    result = client.webhooks.sample(event: event, organization: organization_uri, scope: scope)

    assert_equal Hash, result.class
    assert_equal "invitee.created", result["event"]
    assert result.key?("payload")
  end

  def test_sample_with_bare_org_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    event = "invitee.created"
    scope = "organization"
    stub(path: "sample_webhook_data?event=#{event}&organization=#{expanded}&scope=#{scope}", response: {body: fixture_file("webhooks/sample"), status: 200})

    result = client.webhooks.sample(event: event, organization: bare_uuid, scope: scope)

    assert_equal Hash, result.class
    assert_equal "invitee.created", result["event"]
  end
end
