module Calendlyr
  class User < Object
    def organization
      @organization ||= Organization.new({"uri" => current_organization}.merge(client: client))
    end

    def event_types(**params)
      client.event_types.list user_uri: uri, organization_uri: current_organization, **params
    end

    def events(**params)
      client.events.list user_uri: uri, organization_uri: current_organization, **params
    end

    def memberships(organization_uri: nil, **params)
      client.organizations.list_memberships user_uri: uri, organization_uri: organization_uri, **params
    end

    def busy_times(start_time:, end_time:, **params)
       client.user_busy_times.list(user_uri: uri, start_time: start_time, end_time: end_time, **params)
    end

    def availability_schedules
      client.user_availability_schedules.list(user_uri: uri)
    end
  end
end
