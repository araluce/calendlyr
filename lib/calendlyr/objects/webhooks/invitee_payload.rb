module Calendlyr
  class Webhooks::InviteePayload < Object
    def associated_event
      client.events.retrieve(event: get_slug(event))
    end

    def associated_routing_form_submission
      client.routing_forms.retrieve_submission(uuid: get_slug(routing_form_submission))
    end

    def associated_invitee_no_show
      client.events.retrieve_invitee_no_show(uuid: get_slug(no_show.uri))
    end
  end
end
