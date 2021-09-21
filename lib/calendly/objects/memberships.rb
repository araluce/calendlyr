module Calendly
  class Membership < Object
    def associated_user
      client.users.retrieve user_uuid: get_slug(user.uri)
    end
  end
end
