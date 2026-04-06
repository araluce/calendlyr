module Calendlyr
  class Client
    BASE_URL = "https://api.calendly.com"
    DEFAULT_OPEN_TIMEOUT = 30
    DEFAULT_READ_TIMEOUT = 30

    attr_reader :token, :open_timeout, :read_timeout

    def initialize(token:, open_timeout: DEFAULT_OPEN_TIMEOUT, read_timeout: DEFAULT_READ_TIMEOUT)
      @token = token
      @open_timeout = open_timeout
      @read_timeout = read_timeout
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

    def respond_to_missing?(method_name, include_private = false)
      resource_name = method_name.to_s.split("_").collect(&:capitalize).join + "Resource"

      Calendlyr.const_defined?(resource_name) || super
    end

    # Avoid returning #<Calendlyr::Client @token="token" ...>
    def inspect
      "#<Calendlyr::Client>"
    end
  end
end
