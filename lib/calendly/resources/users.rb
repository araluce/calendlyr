module Calendly
  class UserResource < Resource
    def me
      retrieve(user_uuid: 'me')
    end

    def retrieve(user_uuid:)
      User.new get_request("users/#{user_uuid}").body.dig("resource"), client: client
    end
  end
end
