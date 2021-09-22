module Calendly
  class EventTypeResource < Resource
    def list(user_uri:, organization_uri:, **params)
      response = get_request("event_types", params: {user: user_uri, organization: organization_uri}.merge(params))
      Collection.from_response(response, key: "collection", type: EventType, client: client)
    end

    def retrieve(event_type_uuid:)
      EventType.new get_request("event_types/#{event_type_uuid}").body.dig("resource").merge(client: client)
    end
  end
end
