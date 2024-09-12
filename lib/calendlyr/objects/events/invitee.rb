module Calendlyr
  class Events::Invitee < Object
    def cancel(reason: nil)
      client.events.cancel_event(uuid: uuid, reason: reason)
    end

    def create_no_shows
      client.events.create_invitee_no_show(invitee: uri)
    end
  end
end
