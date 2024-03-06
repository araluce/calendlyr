require "calendlyr/version"

module Calendlyr
  autoload :Client, "calendlyr/client"
  autoload :Collection, "calendlyr/collection"
  autoload :Resource, "calendlyr/resource"
  autoload :Object, "calendlyr/object"

  # Errors
  autoload :ResponseErrorHandler, "calendlyr/error"
  autoload :Error, "calendlyr/error"
  autoload :PermissionDenied, "calendlyr/error"
  autoload :BadRequest, "calendlyr/error"
  autoload :PaymentRequired, "calendlyr/error"
  autoload :Unauthenticated, "calendlyr/error"
  autoload :NotFound, "calendlyr/error"
  autoload :ExternalCalendarEror, "calendlyr/error"
  autoload :InternalServerError, "calendlyr/error"

  # High-level categories of Calendly API calls
  autoload :UserResource, "calendlyr/resources/users"
  autoload :EventTypeResource, "calendlyr/resources/event_types"
  autoload :OrganizationResource, "calendlyr/resources/organizations"
  autoload :EventResource, "calendlyr/resources/events"
  autoload :EventInviteeResource, "calendlyr/resources/event_invitees"
  autoload :SchedulingLinkResource, "calendlyr/resources/scheduling_links"
  autoload :WebhookResource, "calendlyr/resources/webhooks"
  autoload :DataComplianceResource, "calendlyr/resources/data_compliance"

  # Classes used to return a nicer object wrapping the response data
  autoload :User, "calendlyr/objects/users"
  autoload :EventType, "calendlyr/objects/event_types"
  autoload :Event, "calendlyr/objects/events"
  autoload :Organization, "calendlyr/objects/organizations"
  autoload :Invitation, "calendlyr/objects/invitations"
  autoload :EventInvitee, "calendlyr/objects/event_invitees"
  autoload :SchedulingLink, "calendlyr/objects/scheduling_links"
  autoload :Membership, "calendlyr/objects/memberships"
  autoload :Webhook, "calendlyr/objects/webhooks"
  autoload :ActivityLog, "calendlyr/objects/activity_log"
end
