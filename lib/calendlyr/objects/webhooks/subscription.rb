module Calendlyr
  class Webhooks::Subscription < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def associated_user
      client.users.retrieve(uuid: get_slug(user))
    end

    def associated_creator
      client.users.retrieve(uuid: get_slug(creator))
    end

    def active?
      state == "active"
    end

    def disabled?
      state == "disabled"
    end
  end
end
