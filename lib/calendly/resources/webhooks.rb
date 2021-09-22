module Calendly
  class WebhookResource < Resource
    def list(organization_uri:, scope:, **params)
      response = get_request("webhook_subscriptions", params: {organization: organization_uri, scope: scope}.merge(params).compact)
      Collection.from_response(response, key: "collection", type: Webhook, client: client)
    end

    def create(resource_uri:, events:, organization_uri:, scope:, signing_key: nil, user_uri: nil)
      body = {url: resource_uri, events: events, organization: organization_uri, user: user_uri, scope: scope, signing_key: signing_key}.compact
      Webhook.new post_request("webhook_subscriptions", body: body).body.dig("resource").merge(client: client)
    end

    def retrieve(webhook_uuid:)
      Webhook.new get_request("webhook_subscriptions/#{webhook_uuid}").body.dig("resource").merge(client: client)
    end

    def delete(webhook_uuid:)
      delete_request("webhook_subscriptions/#{webhook_uuid}")
    end
  end
end
