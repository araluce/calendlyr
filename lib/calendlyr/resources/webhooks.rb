module Calendlyr
  class WebhooksResource < Resource
    def list(organization:, scope:, **params)
      response = get_request("webhook_subscriptions", params: params.merge(organization: organization, scope: scope).compact)
      Collection.from_response(response, type: Webhooks::Subscription, client: client)
    end

    def create(url:, events:, organization:, scope:, **params)
      body = params.merge(url: url, events: events, organization: organization, scope: scope)
      Webhooks::Subscription.new post_request("webhook_subscriptions", body: body).dig("resource").merge(client: client)
    end

    def retrieve(webhook_uuid:)
      Webhooks::Subscription.new get_request("webhook_subscriptions/#{webhook_uuid}").dig("resource").merge(client: client)
    end

    def delete(webhook_uuid:)
      delete_request("webhook_subscriptions/#{webhook_uuid}")
    end
  end
end
