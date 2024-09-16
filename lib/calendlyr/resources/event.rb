module Calendlyr
  class EventResource < Resource
    def list(**params)
      response = get_request("scheduled_events", params: params)
      Collection.from_response(response, type: Event, client: client)
    end

    def retrieve(uuid:)
      Event.new get_request("scheduled_events/#{uuid}").dig("resource").merge(client: client)
    end

    def cancel(uuid:, reason: nil)
      Events::Cancellation.new post_request("scheduled_events/#{uuid}/cancellation", body: {reason: reason}).dig("resource").merge(client: client)
    end

    # Invitee
    def list_invitees(uuid:, **params)
      response = get_request("scheduled_events/#{uuid}/invitees", params: params)
      Collection.from_response(response, type: Events::Invitee, client: client)
    end

    def retrieve_invitee(event_uuid:, invitee_uuid:)
      Events::Invitee.new get_request("scheduled_events/#{event_uuid}/invitees/#{invitee_uuid}").dig("resource").merge(client: client)
    end

    # Invitee No Show
    def retrieve_invitee_no_show(uuid:)
      Events::InviteeNoShow.new get_request("invitee_no_shows/#{uuid}").dig("resource").merge(client: client)
    end

    def create_invitee_no_show(invitee:)
      body = {invitee: invitee}
      Events::InviteeNoShow.new post_request("invitee_no_shows", body: body).dig("resource").merge(client: client)
    end

    def delete_invitee_no_show(uuid:)
      delete_request("invitee_no_shows/#{uuid}")
    end
  end
end
