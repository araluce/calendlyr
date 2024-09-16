module Calendlyr
  class Client
    BASE_URL = "https://api.calendly.com"

    attr_reader :token

    def initialize(token:)
      @token = token
    end

    def availability
      AvailabilityResource.new(self)
    end

    def me(force_reload: false)
      @me = nil if force_reload
      @me ||= users.me
    end

    def organization
      me.organization
    end

    def users
      UserResource.new(self)
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

    def groups
      GroupResource.new(self)
    end

    def outgoing_communications
      OutgoingCommunicationResource.new(self)
    end

    def routing_forms
      RoutingFormResource.new(self)
    end

    def scheduling_links
      SchedulingLinkResource.new(self)
    end

    def shares
      ShareResource.new(self)
    end

    def webhooks
      WebhookResource.new(self)
    end

    def data_compliance
      DataComplianceResource.new(self)
    end

    # Avoid returning #<Calendlyr::Client @token="token" ...>
    def inspect
      "#<Calendlyr::Client>"
    end
  end
end
