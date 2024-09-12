module Calendlyr
  class Group < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def events(**params)
      client.events.list(**params.merge(group: uri))
    end

    def group_relationships(**params)
      client.groups.list_relationships(**params.merge(group: uri))
    end
  end
end
