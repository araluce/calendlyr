module Calendly
  class User < Object
    def organization
      @organization ||= Organization.new({ "uri" => current_organization }, client: client)
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
  end
end
