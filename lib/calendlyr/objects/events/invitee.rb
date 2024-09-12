module Calendlyr
  class Events::Invitee < Object
    def create_no_shows
      client.events.create_invitee_no_show(invitee: uri)
    end
  end
end
