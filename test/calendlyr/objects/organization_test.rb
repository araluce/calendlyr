# frozen_string_literal: true

require "test_helper"

class OrganizatonObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/organization")).merge(client: client)
    @organization = Calendlyr::Organization.new(json)

    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/AAAAAAAAAAAAAAAA", response: response)
  end

  def test_activity_logs
    response = {body: fixture_file("activity_log/list"), status: 200}
    stub(path: "activity_log_entries?organization=#{@organization.uri}", response: response)

    activity_logs = @organization.activity_logs

    assert_equal 1, activity_logs.data.size
    assert_equal Calendlyr::ActivityLog, activity_logs.data.first.class
  end

  def test_events
    response = {body: fixture_file("events/list"), status: 200}
    stub(path: "scheduled_events?organization=#{@organization.uri}", response: response)

    events = @organization.events

    assert_equal 1, events.data.size
    assert_equal Calendlyr::Event, events.data.first.class
  end

  def test_event_types
    response = {body: fixture_file("event_types/list"), status: 200}
    stub(path: "event_types?organization=#{@organization.uri}", response: response)

    event_types = @organization.event_types

    assert_equal 1, event_types.data.size
    assert_equal Calendlyr::EventType, event_types.data.first.class
  end

  def test_group_relationships
    response = {body: fixture_file("group_relationships/list"), status: 200}
    stub(path: "group_relationships?organization=#{@organization.uri}", response: response)

    group_relationships = @organization.group_relationships

    assert_equal 3, group_relationships.data.size
    assert_equal Calendlyr::Groups::Relationship, group_relationships.data.first.class
  end

  def test_memberships
    response = {body: fixture_file("organization_memberships/list"), status: 200}
    stub(path: "organization_memberships?organization=#{@organization.uri}", response: response)

    memberships = @organization.memberships

    assert_equal 1, memberships.data.size
    assert_equal Calendlyr::Organizations::Membership, memberships.data.first.class
  end

  def test_membership
    response = {body: fixture_file("organization_memberships/retrieve"), status: 200}
    stub(path: "organization_memberships/AAAAAAAAAAAAAAAA", response: response)

    membership = @organization.membership(uuid: "AAAAAAAAAAAAAAAA")

    assert_equal Calendlyr::User, membership.associated_user.class
    assert_equal Calendlyr::Organizations::Membership, membership.class
  end

  def test_webhooks
    scope = "user"
    response = {body: fixture_file("webhooks/list"), status: 200}
    stub(path: "webhook_subscriptions?organization=#{@organization.uri}&scope=#{scope}", response: response)
    webhooks = @organization.webhooks(scope: scope)

    assert_equal Calendlyr::Collection, webhooks.class
    assert_equal Calendlyr::Webhooks::Subscription, webhooks.data.first.class
    assert_equal 1, webhooks.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", webhooks.next_page_token
  end

  def test_create_webhook
    user_uri = "https://api.calendly.com/users/AAAAAAAAAAAAAAAA"
    body = {url: "https://blah.foo/bar", events: ["invitee.created"], scope: "user", user: user_uri}
    stub(method: :post, path: "webhook_subscriptions", body: body.merge(organization: @organization.uri), response: {body: fixture_file("webhooks/create"), status: 201})

    assert @organization.create_webhook(**body)
  end

  def test_invite_user
    email = "email@example.com"
    response = {body: fixture_file("organizations/invite"), status: 201}
    stub(method: :post, path: "organizations/#{@organization.uuid}/invitations", body: {email: email}, response: response)
    invitation = @organization.invite_user(email: email)

    assert_equal Calendlyr::Organizations::Invitation, invitation.class
    assert_equal email, invitation.email
  end

  def test_invitations
    response = {body: fixture_file("organizations/list_invitations"), status: 200}
    stub(path: "organizations/#{@organization.uuid}/invitations", response: response)
    invitations = @organization.invitations

    assert_equal Calendlyr::Collection, invitations.class
    assert_equal Calendlyr::Organizations::Invitation, invitations.data.first.class
    assert_equal 1, invitations.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", invitations.next_page_token
  end

  def test_organization_invitation
    response = {body: fixture_file("organizations/retrieve_invitation"), status: 200}
    stub(path: "organizations/#{@organization.uuid}/invitations/abc123", response: response)
    invitation = @organization.invitation(invitation_uuid: "abc123")

    assert_equal Calendlyr::Organizations::Invitation, invitation.class
    assert_equal "test@example.com", invitation.email
  end

  def test_revoke_invitation
    stub(method: :delete, path: "organizations/#{@organization.uuid}/invitations/abc123", response: {body: fixture_file("organizations/revoke_invitation")})
    assert @organization.revoke_invitation(invitation_uuid: "abc123")
  end
end
