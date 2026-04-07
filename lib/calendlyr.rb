require "calendlyr/version"

module Calendlyr
  autoload :Client, "calendlyr/client"
  autoload :Configuration, "calendlyr/configuration"
  autoload :Collection, "calendlyr/collection"
  autoload :Object, "calendlyr/object"
  autoload :Resource, "calendlyr/resource"

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      raise ArgumentError, "Missing Calendly token. Configure it with Calendlyr.configure { |c| c.token = \"...\" }" if configuration.token.nil?

      signature = configuration_signature
      @client = nil if @client_signature != signature
      @client ||= Client.new(**client_attributes)
      @client_signature = signature
      @client
    end

    def reset!
      @configuration = nil
      @client = nil
      @client_signature = nil
    end

    private

    def configuration_signature
      [configuration.token, configuration.open_timeout, configuration.read_timeout]
    end

    def client_attributes
      {
        token: configuration.token,
        open_timeout: configuration.open_timeout,
        read_timeout: configuration.read_timeout
      }
    end
  end

  # Errors
  autoload :ERROR_TYPES, "calendlyr/error"
  autoload :BadRequest, "calendlyr/error"
  autoload :Error, "calendlyr/error"
  autoload :ExternalCalendarError, "calendlyr/error"
  autoload :InternalServerError, "calendlyr/error"
  autoload :NotFound, "calendlyr/error"
  autoload :PaymentRequired, "calendlyr/error"
  autoload :PermissionDenied, "calendlyr/error"
  autoload :Unauthenticated, "calendlyr/error"
  autoload :TooManyRequests, "calendlyr/error"
  autoload :ResponseErrorHandler, "calendlyr/error"

  # High-level categories of Calendly API calls
  autoload :AvailabilityResource, "calendlyr/resources/availability"
  autoload :DataComplianceResource, "calendlyr/resources/data_compliance"
  autoload :EventsResource, "calendlyr/resources/events"
  autoload :EventTypesResource, "calendlyr/resources/event_types"
  autoload :GroupsResource, "calendlyr/resources/groups"
  autoload :OrganizationsResource, "calendlyr/resources/organizations"
  autoload :LocationsResource, "calendlyr/resources/locations"
  autoload :RoutingFormsResource, "calendlyr/resources/routing_forms"
  autoload :SharesResource, "calendlyr/resources/shares"
  autoload :UsersResource, "calendlyr/resources/users"
  autoload :WebhooksResource, "calendlyr/resources/webhooks"

  # Classes used to return a nicer object wrapping the response data
  autoload :ActivityLog, "calendlyr/objects/activity_log"
  autoload :Event, "calendlyr/objects/event"
  autoload :EventType, "calendlyr/objects/event_type"
  autoload :Group, "calendlyr/objects/group"
  autoload :Organization, "calendlyr/objects/organization"
  autoload :Location, "calendlyr/objects/location"
  autoload :RoutingForm, "calendlyr/objects/routing_form"
  autoload :Share, "calendlyr/objects/share"
  autoload :User, "calendlyr/objects/user"

  module Availabilities
    autoload :Rule, "calendlyr/objects/availabilities/rule"
    autoload :UserSchedule, "calendlyr/objects/availabilities/user_schedule"
    autoload :UserBusyTime, "calendlyr/objects/availabilities/user_busy_time"
  end

  module Events
    autoload :Cancellation, "calendlyr/objects/events/cancellation"
    autoload :Guest, "calendlyr/objects/events/guest"
    autoload :Invitee, "calendlyr/objects/events/invitee"
    autoload :InviteeNoShow, "calendlyr/objects/events/invitee_no_show"
  end

  module EventTypes
    autoload :AvailabilitySchedule, "calendlyr/objects/event_types/availability_schedule"
    autoload :Profile, "calendlyr/objects/event_types/profile"
  end

  module Groups
    autoload :Relationship, "calendlyr/objects/groups/relationship"
  end

  module Organizations
    autoload :Invitation, "calendlyr/objects/organizations/invitation"
    autoload :Membership, "calendlyr/objects/organizations/membership"
  end

  module RoutingForms
    autoload :Submission, "calendlyr/objects/routing_forms/submission"
  end

  module Webhooks
    autoload :Subscription, "calendlyr/objects/webhooks/subscription"
    autoload :InviteePayload, "calendlyr/objects/webhooks/invitee_payload"
    autoload :Payload, "calendlyr/objects/webhooks/payload"
  end
end
