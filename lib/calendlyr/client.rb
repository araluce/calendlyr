module Calendlyr
  class Client
    BASE_URL = "https://api.calendly.com"

    attr_reader :token

    def initialize(token:)
      @token = token
    end

    def me(force_reload: false)
      @me = nil if force_reload
      @me ||= users.me
    end

    def organization
      me.organization
    end

    # Given a client.users, method_missing behaves like this:
    # def users
    #  UsersResource.new(self)
    # end
    def method_missing(method_name, *args, &block)
      resource_name = method_name.to_s.split("_").collect(&:capitalize).join + "Resource"
      if Calendlyr.const_defined?(resource_name)
        Calendlyr.const_get(resource_name).new(self)
      else
        super
      end
    end

    # Avoid returning #<Calendlyr::Client @token="token" ...>
    def inspect
      "#<Calendlyr::Client>"
    end
  end
end
