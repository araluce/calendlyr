module Calendlyr
  class User < Object
    def organization
      Organization.new({"uri" => current_organization}.merge(client: client))
    end

    def availability_schedules(**params)
      client.availability.list_user_schedules(**params.merge(user: uri))
    end

    def organization_memberships(**params)
      client.organization.memberships(**params.merge(user: uri))
    end

    def event_types(**params)
      client.event_types.list(**params.merge(user: uri))
    end

    def events(**params)
      client.events.list(**params.merge(user: uri, organization: current_organization))
    end

    def memberships(**params)
      client.organizations.list_memberships(**params.merge(user: uri))
    end

    def membership(uuid:)
      client.organizations.retrieve_membership(uuid: uuid)
    end

    def busy_times(start_time:, end_time:, **params)
      client.availability.list_user_busy_times(**params.merge(user: uri, start_time: start_time, end_time: end_time))
    end
  end
end
