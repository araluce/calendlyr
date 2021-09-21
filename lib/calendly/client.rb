module Calendly
  class Client
    BASE_URL = "https://api.calendly.com"

    attr_reader :api_key, :adapter

    def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @adapter = adapter

      # Test stubs for requests
      @stubs = stubs
    end

    def users
      UserResource.new(self)
    end

    def me
      users.me
    end

    def organizations
      OrganizationResource.new(self)
    end

    def event_types
      EventTypeResource.new(self)
    end

    def events
      EventResource.new(self)
    end

    def event_invitees
      EventInviteeResource.new(self)
    end

    def scheduling_links
      SchedulingLinkResource.new(self)
    end

    def webhooks
      WebhookResource.new(self)
    end

    def data_compliance
      DataComplianceResource.new(self)
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.request :authorization, :Bearer, api_key
        conn.request :json

        conn.response :dates
        conn.response :json, content_type: "application/json"

        conn.adapter adapter, @stubs
      end
    end

    # Avoid returning #<Calendly::Client @api_key="api_key" ...>
    def inspect
      "#<Calendly::Client>"
    end
  end
end
