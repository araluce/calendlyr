# frozen_string_literal: true

require "test_helper"

class OrganizationsResourceTest < Minitest::Test
  def test_invite
    organization_uuid = "ABCDABCDABCDABCD"
    email = "email@example.com"
    stub = stub_request("organizations/#{organization_uuid}/invitations", method: :post, body: {email: email}, response: stub_response(fixture: "organizations/invite", status: 201))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    invitation = client.organizations.invite(organization_uuid: organization_uuid, email: email)

    assert_equal Calendly::Invitation, invitation.class
    assert_equal email, invitation.email
  end

  def test_list_invitations
    organization_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organizations/#{organization_uuid}/invitations", response: stub_response(fixture: "organizations/list_invitations"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    invitations = client.organizations.list_invitations(organization_uuid: organization_uuid)

    assert_equal Calendly::Collection, invitations.class
    assert_equal Calendly::Invitation, invitations.data.first.class
    assert_equal 1, invitations.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", invitations.next_page_token
  end

  def test_list_memberships
    user_uri = "AAAAAAAAAAAAAAAA"
    organization_uri = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organization_memberships?user=#{user_uri}&organization=#{organization_uri}", response: stub_response(fixture: "organizations/list_memberships"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    memberships = client.organizations.list_memberships(user_uri: user_uri, organization_uri: organization_uri)

    assert_equal Calendly::Collection, memberships.class
    assert_equal Calendly::Membership, memberships.data.first.class
    assert_equal 1, memberships.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end

  def test_retrieve_invitation
    organization_uuid = "AAAAAAAAAAAAAAAA"
    invitation_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organizations/#{organization_uuid}/invitations/#{invitation_uuid}", response: stub_response(fixture: "organizations/retrieve_invitation"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    invitation = client.organizations.retrieve_invitation(organization_uuid: organization_uuid, invitation_uuid: invitation_uuid)

    assert_equal Calendly::Invitation, invitation.class
    assert_equal "test@example.com", invitation.email
  end

  def test_retrieve_membership
    membership_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organization_memberships/#{membership_uuid}", response: stub_response(fixture: "organizations/retrieve_membership"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    membership = client.organizations.retrieve_membership(membership_uuid: membership_uuid)

    assert_equal Calendly::Membership, membership.class
    assert_equal "test@example.com", membership.user.email
  end

  def test_revoke_invitation
    organization_uuid = "AAAAAAAAAAAAAAAA"
    invitation_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organizations/#{organization_uuid}/invitations/#{invitation_uuid}", method: :delete, response: stub_response(fixture: "organizations/revoke_invitation", status: 204))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.organizations.revoke_invitation(organization_uuid: organization_uuid, invitation_uuid: invitation_uuid)
  end

  def test_remove_user
    membership_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("organization_memberships/#{membership_uuid}", method: :delete, response: stub_response(fixture: "organizations/remove_user", status: 204))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.organizations.remove_user(membership_uuid: membership_uuid)
  end
end
