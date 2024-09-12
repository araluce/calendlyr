module Calendlyr
  class EventType < Object
    def associated_profile
      EventTypes::Profile.new(profile.to_h.merge(client: client))
    end

    def create_share(**params)
      client.shares.create(**params.merge(event_type: uri))
    end

    def available_times(start_time:, end_time:, **params)
      client.event_types.list_available_times(**params.merge(event_type: uri, start_time: start_time, end_time: end_time))
    end
  end
end
