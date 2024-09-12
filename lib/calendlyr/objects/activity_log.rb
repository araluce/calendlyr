module Calendlyr
  class ActivityLog < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def associated_actor
      client.users.retrieve(uuid: get_slug(actor.uri))
    end
  end
end
