# frozen_string_literal: true

require "test_helper"

class OrganizationsResourceTest < Minitest::Test
  def test_invite
    organization_uuid = "ABCDABCDABCDABCD"
    email = "email@example.com"
    response = {body: fixture_file("organizations/invite"), status: 201}
    stub(method: :post, path: "organizations/#{organization_uuid}/invitations", body: {email: email}, response: response)

    invitation = client.organizations.invite(organization_uuid: organization_uuid, email: email)

    assert_equal Calendlyr::Invitation, invitation.class
    assert_equal email, invitation.email
  end

  def test_list_invitations
    organization_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/list_invitations"), status: 200}
    stub(path: "organizations/#{organization_uuid}/invitations", response: response)
    invitations = client.organizations.list_invitations(organization_uuid: organization_uuid)

    assert_equal Calendlyr::Collection, invitations.class
    assert_equal Calendlyr::Invitation, invitations.data.first.class
    assert_equal 1, invitations.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", invitations.next_page_token
  end

  def test_list_memberships
    user_uri = "AAAAAAAAAAAAAAAA"
    organization_uri = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/list_memberships"), status: 200}
    stub(path: "organization_memberships?user=#{user_uri}&organization=#{organization_uri}", response: response)
    memberships = client.organizations.list_memberships(user_uri: user_uri, organization_uri: organization_uri)

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal Calendlyr::Membership, memberships.data.first.class
    assert_equal 1, memberships.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end

  def test_retrieve_invitation
    organization_uuid = "AAAAAAAAAAAAAAAA"
    invitation_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/retrieve_invitation"), status: 200}
    stub(path: "organizations/#{organization_uuid}/invitations/#{invitation_uuid}", response: response)
    invitation = client.organizations.retrieve_invitation(organization_uuid: organization_uuid, invitation_uuid: invitation_uuid)

    assert_equal Calendlyr::Invitation, invitation.class
    assert_equal "test@example.com", invitation.email
  end

  def test_retrieve_membership
    membership_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/retrieve_membership"), status: 200}
    stub(path: "organization_memberships/#{membership_uuid}", response: response)
    membership = client.organizations.retrieve_membership(membership_uuid: membership_uuid)

    assert_equal Calendlyr::Membership, membership.class
    assert_equal "test@example.com", membership.user.email
  end

  def test_revoke_invitation
    organization_uuid = "AAAAAAAAAAAAAAAA"
    invitation_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/revoke_invitation")}
    stub(method: :delete, path: "organizations/#{organization_uuid}/invitations/#{invitation_uuid}", response: response)
    assert client.organizations.revoke_invitation(organization_uuid: organization_uuid, invitation_uuid: invitation_uuid)
  end

  def test_remove_user
    membership_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("organizations/remove_user")}
    stub(method: :delete, path: "organization_memberships/#{membership_uuid}", response: response)
    assert client.organizations.remove_user(membership_uuid: membership_uuid)
  end

  def test_organization_invite_user
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})

    email = "email@example.com"
    response = {body: fixture_file("organizations/invite"), status: 201}
    stub(method: :post, path: "organizations/#{client.organization.uuid}/invitations", body: {email: email}, response: response)

    invitation = client.organization.invite_user(email: email)

    assert_equal Calendlyr::Invitation, invitation.class
    assert_equal email, invitation.email
  end

  def test_organization_list_invitations
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    stub(path: "organizations/#{client.organization.uuid}/invitations", response: {body: fixture_file("organizations/list_invitations"), status: 200})
    invitations = client.organization.list_invitations

    assert_equal Calendlyr::Collection, invitations.class
    assert_equal Calendlyr::Invitation, invitations.data.first.class
    assert_equal 1, invitations.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", invitations.next_page_token
  end

  def test_organization_revoke_invitation
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    stub(method: :delete, path: "organizations/#{client.organization.uuid}/invitations/AAAAAAAAAAAAAAAA", response: {body: fixture_file("organizations/revoke_invitation")})
    assert client.organization.revoke_invitation(invitation_uuid: "AAAAAAAAAAAAAAAA")
  end

  def test_organization_invitation
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    response = {body: fixture_file("organizations/retrieve_invitation"), status: 200}
    stub(path: "organizations/#{client.organization.uuid}/invitations/AAAAAAAAAAAAAAAA", response: response)
    invitation = client.organization.invitation(invitation_uuid: "AAAAAAAAAAAAAAAA")

    assert_equal Calendlyr::Invitation, invitation.class
    assert_equal "test@example.com", invitation.email
  end

  def test_organization_events
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    stub(path: "scheduled_events?organization=#{client.organization.uri}", response: {body: fixture_file("events/list"), status: 200})
    events = client.organization.events

    assert_equal Calendlyr::Collection, events.class
    assert_equal Calendlyr::Event, events.data.first.class
    assert_equal 1, events.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_organization_memberships
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    stub(path: "organization_memberships?organization=#{client.organization.uri}", response: {body: fixture_file("organizations/list_memberships"), status: 200})
    memberships = client.organization.memberships

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal Calendlyr::Membership, memberships.data.first.class
    assert_equal 1, memberships.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end
end
