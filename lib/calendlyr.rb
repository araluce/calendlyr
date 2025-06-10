require "calendlyr/version"

module Calendlyr
  autoload :Client, "calendlyr/client"
  autoload :Collection, "calendlyr/collection"
  autoload :Object, "calendlyr/object"
  autoload :Resource, "calendlyr/resource"

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
  autoload :OutgoingCommunicationsResource, "calendlyr/resources/outgoing_communications"
  autoload :RoutingFormsResource, "calendlyr/resources/routing_forms"
  autoload :SchedulingLinksResource, "calendlyr/resources/scheduling_links"
  autoload :SharesResource, "calendlyr/resources/shares"
  autoload :UsersResource, "calendlyr/resources/users"
  autoload :WebhooksResource, "calendlyr/resources/webhooks"

  # Classes used to return a nicer object wrapping the response data
  autoload :ActivityLog, "calendlyr/objects/activity_log"
  autoload :Event, "calendlyr/objects/event"
  autoload :EventType, "calendlyr/objects/event_type"
  autoload :Group, "calendlyr/objects/group"
  autoload :Organization, "calendlyr/objects/organization"
  autoload :RoutingForm, "calendlyr/objects/routing_form"
  autoload :SchedulingLink, "calendlyr/objects/scheduling_link"
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
    autoload :AvailableTime, "calendlyr/objects/event_types/available_time"
    autoload :Membership, "calendlyr/objects/event_types/membership"
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
