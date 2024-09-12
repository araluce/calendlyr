module Calendlyr
  class EventTypes::Profile < Object
    def associated_owner
      client.users.retrieve(uuid: get_slug(owner))
    end
  end
end
