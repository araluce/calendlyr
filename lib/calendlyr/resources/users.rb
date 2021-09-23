module Calendlyr
  class UserResource < Resource
    def me
      retrieve(user_uuid: "me")
    end

    def retrieve(user_uuid:)
      User.new get_request("users/#{user_uuid}").dig("resource").merge(client: client)
    end
  end
end
