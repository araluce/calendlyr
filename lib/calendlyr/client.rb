module Calendlyr
  class Client
    BASE_URL = "https://api.calendly.com"

    attr_reader :token

    def initialize(token:)
      @token = token
    end

    def me(force_reload: false)
      memoize(@me, force_reload: force_reload) { users.me }
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

    private

    def memoize(instance_variable, force_reload: false, &block)
      return instance_variable if instance_variable && !force_reload
      instance_variable = block.call
    end
  end
end
