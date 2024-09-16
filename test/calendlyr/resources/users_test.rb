# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_retrieve
    user_uuid = "abc123"
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{user_uuid}", response: response)
    user = client.users.retrieve(uuid: user_uuid)

    assert_equal Calendlyr::User, user.class
    assert_equal "https://api.calendly.com/users/abc123", user.uri
    assert_equal "John Doe", user.name
    assert_equal "acmesales", user.slug
    assert_equal "test@example.com", user.email
  end

  def test_me
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/me", response: response)
    me = client.me

    assert_equal Calendlyr::User, me.class
    assert_equal "https://api.calendly.com/users/abc123", me.uri
    assert_equal "John Doe", me.name
    assert_equal "acmesales", me.slug
    assert_equal "test@example.com", me.email
  end

  def test_me_caching
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub = stub(path: "users/me", response: response)
    me = client.me
    remove_request_stub(stub)
    assert_equal client.me, me
  end

  def test_me_caching_reload
    me = client.me
    stub(path: "users/me", response: {body: fixture_file("users/reload"), status: 200})
    reloaded_me = client.me(force_reload: true)
    assert me.name != reloaded_me.name
  end

  def test_organization
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/me", response: response)
    organization = client.organization

    assert_equal Calendlyr::Organization, organization.class
    assert_equal "https://api.calendly.com/organizations/abc123", organization.uri
    assert_equal "abc123", organization.uuid
  end

  def test_memberships
    me = client.me

    stub(path: "organization_memberships?user=#{me.uri}&organization=#{me.organization.uri}", response: {body: fixture_file("organizations/list_memberships"), status: 200})
    memberships = client.me.memberships(organization: me.organization.uri)

    assert_equal Calendlyr::Collection, memberships.class
    assert_equal Calendlyr::Organizations::Membership, memberships.data.first.class
    assert_equal 1, memberships.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end
end
