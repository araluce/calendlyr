module Calendlyr
  class WebhooksResource < Resource
    def list(organization:, scope:, **params)
      next_page_caller = ->(page_token:) { list(organization: organization, scope: scope, **params, page_token: page_token) }
      organization = expand_uri(organization, "organizations")
      response = get_request("webhook_subscriptions", params: params.merge(organization: organization, scope: scope).compact)
      Collection.from_response(response, type: Webhooks::Subscription, client: client, next_page_caller: next_page_caller)
    end

    def list_all(organization:, scope:, **params)
      list(organization: organization, scope: scope, **params).auto_paginate.to_a
    end

    def create(url:, events:, organization:, scope:, **params)
      organization = expand_uri(organization, "organizations")
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
