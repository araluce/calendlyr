module Calendlyr
  class EventTypes::Membership < Object
    def associated_event_type
      client.event_types.retrieve(uuid: get_slug(event_type.uri))
    end

    def associated_member
      client.users.retrieve(uuid: get_slug(member.uri))
    end
  end
end
