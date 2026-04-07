# frozen_string_literal: true

require "test_helper"

class OrganizationsResourceTest < Minitest::Test
  def test_retrieve
    organization_uuid = "012345678901234567890"
    stub(path: "organizations/#{organization_uuid}", response: {body: fixture_file("organizations/retrieve"), status: 200})

    organization = client.organizations.retrieve(uuid: organization_uuid)

    assert_equal Calendlyr::Organization, organization.class
    assert_equal "https://api.calendly.com/organizations/012345678901234567890", organization.uri
    assert_equal "Sales Team", organization.name
    assert_equal "professional", organization.plan
  end

  def test_invite
    organization_uuid = "ABCDABCDABCDABCD"
    email = "email@example.com"
    response = {body: fixture_file("organizations/invite"), status: 201}
    stub(method: :post, path: "organizations/#{organization_uuid}/invitations", body: {email: email}, response: response)

    invitation = client.organizations.invite(organization_uuid: organization_uuid, email: email)

    assert_equal Calendlyr::Organizations::Invitation, invitation.class
    assert_equal email, invitation.email
  end

  def test_list_invitations
    organization_uuid = "abc123"
    response = {body: fixture_file("organizations/list_invitations"), status: 200}
    stub(path: "organizations/#{organization_uuid}/invitations", response: response)
    invitations = client.organizations.list_invitations(uuid: organization_uuid)

    assert_equal Calendlyr::Collection, invitations.class
    assert_equal Calendlyr::Organizations::Invitation, invitations.data.first.class
    assert_equal 1, invitations.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", invitations.next_page_token
  end

  def test_create_webhook
    body = {url: "https://blah.foo/bar", events: ["invitee.created"], organization: client.organization.uri, scope: "user", user: client.me.uri}
    stub(method: :post, path: "webhook_subscriptions", body: body, response: {body: fixture_file("webhooks/create"), status: 201})

    assert client.webhooks.create(**body)
  end

  def test_retrieve_invitation
    invitation_uuid = "abc123"

    stub(path: "organizations/#{client.organization.uuid}/invitations/#{invitation_uuid}", response: {body: fixture_file("organizations/retrieve_invitation"), status: 200})
    stub(method: :delete, path: "organizations/#{client.organization.uuid}/invitations/#{invitation_uuid}", response: {body: fixture_file("organizations/revoke_invitation")})
    invitation = client.organizations.retrieve_invitation(org_uuid: client.organization.uuid, uuid: invitation_uuid)

    assert_equal Calendlyr::Organizations::Invitation, invitation.class
    assert_equal "test@example.com", invitation.email

    assert invitation.associated_organization
    assert invitation.revoke
  end

  def test_revoke_invitation
    organization_uuid = "abc123"
    invitation_uuid = "abc123"
    response = {body: fixture_file("organizations/revoke_invitation")}
    stub(method: :delete, path: "organizations/#{organization_uuid}/invitations/#{invitation_uuid}", response: response)
    assert client.organizations.revoke_invitation(org_uuid: organization_uuid, uuid: invitation_uuid)
  end

  # Memberships
  def test_list_memberships
    user_uri = "https://api.calendly.com/users/abc123"
    organization_uri = "https://api.calendly.com/organizations/abc123"
    response = {body: fixture_file("organizations/list_memberships"), status: 200}
    stub(path: "organization_memberships?user=#{user_uri}&organization=#{organization_uri}", response: response)
    memberships = client.organizations.list_memberships(user: user_uri, organization: organization_uri)

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal Calendlyr::Organizations::Membership, memberships.data.first.class
    assert_equal 1, memberships.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end

  def test_activity_log_with_bare_org_uuid
    bare_uuid = "ORG-2"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    response = {body: fixture_file("activity_log/list"), status: 200}
    stub(path: "activity_log_entries?organization=#{expanded}", response: response)

    result = client.organizations.activity_log(organization: bare_uuid)

    assert_equal Calendlyr::Collection, result.class
  end

  def test_list_memberships_with_bare_user_uuid
    bare_uuid = "USER-1"
    expanded = "https://api.calendly.com/users/#{bare_uuid}"
    response = {body: fixture_file("organizations/list_memberships"), status: 200}
    stub(path: "organization_memberships?user=#{expanded}", response: response)

    memberships = client.organizations.list_memberships(user: bare_uuid)

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal 1, memberships.data.count
  end

  def test_list_memberships_with_bare_org_uuid
    bare_uuid = "ORG-1"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    response = {body: fixture_file("organizations/list_memberships"), status: 200}
    stub(path: "organization_memberships?organization=#{expanded}", response: response)

    memberships = client.organizations.list_memberships(organization: bare_uuid)

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal 1, memberships.data.count
  end

  def test_retrieve_membership
    membership_uuid = "abc123"
    response = {body: fixture_file("organizations/retrieve_membership"), status: 200}
    stub(path: "organization_memberships/#{membership_uuid}", response: response)
    stub(path: "users/#{membership_uuid}", response: {body: fixture_file("users/retrieve"), status: 200})
    membership = client.organizations.retrieve_membership(uuid: membership_uuid)

    assert_equal Calendlyr::Organizations::Membership, membership.class
    assert_equal "test@example.com", membership.user.email
    assert_equal membership.associated_user, client.users.retrieve(uuid: membership_uuid)
  end

  def test_remove_user
    membership_uuid = "abc123"
    response = {body: fixture_file("organizations/remove_user")}
    stub(method: :delete, path: "organization_memberships/#{membership_uuid}", response: response)
    assert client.organizations.remove_user(uuid: membership_uuid)
  end

  def test_list_all_memberships_returns_all_pages
    user_uri = "https://api.calendly.com/users/abc123"
    organization_uri = "https://api.calendly.com/organizations/abc123"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("organizations/list_memberships"), status: 200}
    page2_response = {body: fixture_file("organizations/list_memberships_page2"), status: 200}
    stub(path: "organization_memberships?user=#{user_uri}&organization=#{organization_uri}", response: page1_response)
    stub(path: "organization_memberships?user=#{user_uri}&organization=#{organization_uri}&page_token=#{token}", response: page2_response)

    memberships = client.organizations.list_all_memberships(user: user_uri, organization: organization_uri)

    assert_equal Array, memberships.class
    assert_equal 2, memberships.size
    assert_equal Calendlyr::Organizations::Membership, memberships.first.class
  end

  def test_list_all_invitations_returns_all_pages
    organization_uuid = "abc123"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("organizations/list_invitations"), status: 200}
    page2_response = {body: fixture_file("organizations/list_invitations_page2"), status: 200}
    stub(path: "organizations/#{organization_uuid}/invitations", response: page1_response)
    stub(path: "organizations/#{organization_uuid}/invitations?page_token=#{token}", response: page2_response)

    invitations = client.organizations.list_all_invitations(uuid: organization_uuid)

    assert_equal Array, invitations.class
    assert_equal 2, invitations.size
    assert_equal Calendlyr::Organizations::Invitation, invitations.first.class
  end

  def test_list_all_activity_log_returns_all_pages
    bare_uuid = "ORG-2"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("activity_log/list"), status: 200}
    page2_response = {body: fixture_file("activity_log/list_page2"), status: 200}
    stub(path: "activity_log_entries?organization=#{expanded}", response: page1_response)
    stub(path: "activity_log_entries?organization=#{expanded}&page_token=#{token}", response: page2_response)

    entries = client.organizations.list_all_activity_log(organization: bare_uuid)

    assert_equal Array, entries.class
    assert_equal 2, entries.size
    assert_equal Calendlyr::ActivityLog, entries.first.class
  end
end
