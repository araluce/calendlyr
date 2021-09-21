module Calendly
  class EventInviteeResource < Resource
    def list(event_uuid:, **params)
      response = get_request("scheduled_events/#{event_uuid}/invitees", params: params.compact)
      Collection.from_response(response, key: "collection", type: EventInvitee, client: client)
    end

    def retrieve(event_uuid:, invitee_uuid:)
      EventInvitee.new get_request("scheduled_events/#{event_uuid}/invitees/#{invitee_uuid}").body, client: client
    end
  end
end
