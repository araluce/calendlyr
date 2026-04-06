module Calendlyr
  class EventType < Object
    def associated_profile
      EventTypes::Profile.new(profile.to_h.merge(client: client))
    end

    def create_share(**params)
      client.shares.create(**params.merge(event_type: uri))
    end
  end
end
