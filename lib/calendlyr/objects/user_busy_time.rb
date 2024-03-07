module Calendlyr
  class UserBusyTime < Object
    def associated_event
      client.events.retrieve event_uuid: get_slug(event.uri)
    end
  end
end
