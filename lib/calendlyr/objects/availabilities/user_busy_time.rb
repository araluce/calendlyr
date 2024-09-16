module Calendlyr
  class Availabilities::UserBusyTime < Object
    def associated_event
      client.events.retrieve(uuid: get_slug(event.uri))
    end
  end
end
