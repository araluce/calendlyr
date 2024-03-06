module Calendlyr
  class EventTypeResource < Resource
    def list(user_uri:, organization_uri:, **params)
      response = get_request("event_types", params: {user: user_uri, organization: organization_uri}.merge(params))
      Collection.from_response(response, type: EventType, client: client)
    end

    def retrieve(event_type_uuid:)
      EventType.new get_request("event_types/#{event_type_uuid}").dig("resource").merge(client: client)
    end
  end
end
