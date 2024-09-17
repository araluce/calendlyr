module Calendlyr
  class UsersResource < Resource
    def me
      retrieve(uuid: "me")
    end

    def retrieve(uuid:)
      User.new get_request("users/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
