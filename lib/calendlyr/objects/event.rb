module Calendlyr
  class Event < Object
    def memberships
      event_memberships.map { |membership| client.users.retrieve(uuid: get_slug(membership.user)) }
    end

    def cancel(reason: nil)
      client.events.cancel(uuid: uuid, reason: reason)
    end
  end
end
