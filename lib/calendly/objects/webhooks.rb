module Calendly
  class Webhook < Object
    def associated_user
      client.users.retrieve(user_uuid: get_slug(user))
    end

    def associated_organization
      @associated_organization ||= Organization.new({"uri" => organization}, client: client)
    end
  end
end
