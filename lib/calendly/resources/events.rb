module Calendly
  class EventResource < Resource
    def list(user_uri:, organization_uri:, **params)
      response = get_request("scheduled_events", params: { user: user_uri, organization: organization_uri }.merge(params).compact)
      Collection.from_response(response, key: "collection", type: Event, client: client)
    end

    def retrieve(event_uuid:)
      Event.new get_request("scheduled_events/#{event_uuid}").body.dig("resource"), client: client
    end
  end
end
