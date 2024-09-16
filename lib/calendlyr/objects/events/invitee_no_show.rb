module Calendlyr
  class Events::InviteeNoShow < Object
    def delete
      client.events.delete_invitee_no_show(uuid: uuid)
    end
  end
end
