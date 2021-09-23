module Calendlyr
  class Client
    BASE_URL = "https://api.calendly.com"

    attr_reader :api_key

    def initialize(api_key:)
      @api_key = api_key
      raise Error, "Add an api_key to use Calendlyr. Calendlyr::Client.new(api_key: 'your_api_key')" unless api_key
    end

    def me
      users.me
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

    # Avoid returning #<Calendlyr::Client @api_key="api_key" ...>
    def inspect
      "#<Calendlyr::Client>"
    end
  end
end
