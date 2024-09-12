module Calendlyr
  class Availabilities::UserBusyTime < Object
    def associated_event
      client.events.retrieve(event: get_slug(event.uri))
    end
  end
end
