module Calendlyr
  class Organizations::Membership < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def associated_user
      client.users.retrieve(uuid: get_slug(user.uri))
    end

    def group_relationships(**params)
      client.groups.list_relationships(**params.merge(owner: uri))
    end
  end
end
