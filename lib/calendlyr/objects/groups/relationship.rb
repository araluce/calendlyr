module Calendlyr
  class Groups::Relationship < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def associated_group
      client.groups.retrieve(uuid: get_slug(group))
    end

    def associated_owner
      client.organizations.retrieve_membership(uuid: get_slug(owner.uri))
    end
  end
end
