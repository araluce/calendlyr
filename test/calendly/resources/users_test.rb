# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_retrieve
    user_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{user_uuid}", response: response)
    user = client.users.retrieve(user_uuid: user_uuid)

    assert_equal Calendly::User, user.class
    assert_equal "https://api.calendly.com/users/AAAAAAAAAAAAAAAA", user.uri
    assert_equal "John Doe", user.name
    assert_equal "acmesales", user.slug
    assert_equal "test@example.com", user.email
  end

  def test_me
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/me", response: response)
    me = client.me

    assert_equal Calendly::User, me.class
    assert_equal "https://api.calendly.com/users/AAAAAAAAAAAAAAAA", me.uri
    assert_equal "John Doe", me.name
    assert_equal "acmesales", me.slug
    assert_equal "test@example.com", me.email
  end

  def test_organization
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/me", response: response)
    organization = client.organization

    assert_equal Calendly::Organization, organization.class
    assert_equal "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA", organization.uri
    assert_equal "AAAAAAAAAAAAAAAA", organization.uuid
  end

  def test_event_types
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    me = client.me

    stub(path: "event_types?user=#{me.uri}&organization=#{me.organization.uri}", response: {body: fixture_file("event_types/list"), status: 200})
    event_types = client.me.event_types

    assert_equal Calendly::Collection, event_types.class
    assert_equal Calendly::EventType, event_types.data.first.class
    assert_equal 1, event_types.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_events
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    me = client.me

    stub(path: "scheduled_events?user=#{me.uri}&organization=#{me.organization.uri}", response: {body: fixture_file("events/list"), status: 200})
    events = client.me.events

    assert_equal Calendly::Collection, events.class
    assert_equal Calendly::Event, events.data.first.class
    assert_equal 1, events.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_memberships
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
    me = client.me

    stub(path: "organization_memberships?user=#{me.uri}&organization=#{me.organization.uri}", response: {body: fixture_file("organizations/list_memberships"), status: 200})
    memberships = client.me.memberships(organization_uri: me.organization.uri)

    assert_equal Calendly::Collection, memberships.class
    assert_equal Calendly::Membership, memberships.data.first.class
    assert_equal 1, memberships.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", memberships.next_page_token
  end
end
