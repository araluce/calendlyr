module Calendlyr
  class SchedulingLink < Object
    def event_type
      return unless owner_type == "EventType"

      client.event_types.retrieve(uuid: get_slug(owner))
    end
  end
end
