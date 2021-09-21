require "faraday"
require "faraday_middleware"
require "calendly/version"

module Calendly
  autoload :Client, "calendly/client"
  autoload :Collection, "calendly/collection"
  autoload :Error, "calendly/error"
  autoload :Resource, "calendly/resource"
  autoload :Object, "calendly/object"

  # High-level categories of Calendly API calls
  autoload :UserResource, "calendly/resources/users"
  autoload :EventTypeResource, "calendly/resources/event_types"
  autoload :OrganizationResource, "calendly/resources/organizations"
  autoload :EventResource, "calendly/resources/events"
  autoload :EventInviteeResource, "calendly/resources/event_invitees"
  autoload :SchedulingLinkResource, "calendly/resources/scheduling_links"
  autoload :WebhookResource, "calendly/resources/webhooks"
  autoload :DataComplianceResource, "calendly/resources/data_compliance"

  # Classes used to return a nicer object wrapping the response data
  autoload :User, "calendly/objects/users"
  autoload :EventType, "calendly/objects/event_types"
  autoload :Event, "calendly/objects/events"
  autoload :Organization, "calendly/objects/organizations"
  autoload :Invitation, "calendly/objects/invitations"
  autoload :EventInvitee, "calendly/objects/event_invitees"
  autoload :SchedulingLink, "calendly/objects/scheduling_links"
  autoload :Membership, "calendly/objects/memberships"
  autoload :Webhook, "calendly/objects/webhooks"
end
