# frozen_string_literal: true

require "test_helper"

class WebhooksResourceTest < Minitest::Test
  def test_list
    organization_uri = "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA"
    scope = "user"
    stub = stub_request("webhook_subscriptions?organization=#{organization_uri}&scope=#{scope}", response: stub_response(fixture: "webhooks/list"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    webhooks = client.webhooks.list(organization_uri: organization_uri, scope: scope)

    assert_equal Calendly::Collection, webhooks.class
    assert_equal Calendly::Webhook, webhooks.data.first.class
    assert_equal 1, webhooks.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", webhooks.next_page_token
  end

  def test_retrieve
    webhook_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("webhook_subscriptions/#{webhook_uuid}", response: stub_response(fixture: "webhooks/retrieve"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    webhook = client.webhooks.retrieve(webhook_uuid: webhook_uuid)

    assert_equal Calendly::Webhook, webhook.class
    assert_equal "user", webhook.scope
  end

  def test_delete
    webhook_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("webhook_subscriptions/#{webhook_uuid}", method: :delete, response: stub_response(fixture: "webhooks/delete", status: 204))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.webhooks.delete(webhook_uuid: webhook_uuid)
  end
end
