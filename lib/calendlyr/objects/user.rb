module Calendlyr
  class User < Object
    def organization
      Organization.new({"uri" => current_organization}.merge(client: client))
    end

    def availability_schedules(**params)
      client.availability.list_user_schedules(**params.merge(user: uri))
    end

    def event_types(**params)
      client.event_types.list(**params.merge(user: uri))
    end

    def events(**params)
      client.events.list(**params.merge(user: uri, organization: current_organization))
    end

    def membership(uuid:)
      organization.membership(uuid: uuid)
    end

    def memberships(**params)
      organization.memberships(**params.merge(user: uri))
    end

    def busy_times(start_time:, end_time:, **params)
      client.availability.list_user_busy_times(**params.merge(user: uri, start_time: start_time, end_time: end_time))
    end
  end
end
