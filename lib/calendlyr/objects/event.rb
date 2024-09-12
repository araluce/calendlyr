module Calendlyr
  class Event < Object
    def memberships
      event_memberships.map { |membership| client.users.retrieve(uuid: get_slug(membership.user)) }
    end
  end
end
