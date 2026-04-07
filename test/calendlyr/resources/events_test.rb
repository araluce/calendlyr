# frozen_string_literal: true

require "test_helper"

class EventsResourceTest < Minitest::Test
  def setup
    @user_uri = "https://api.calendly.com/users/abc123"
    @organization_uri = "https://api.calendly.com/organizations/abc123"
    @event_uuid = "abc123"
    list_response = {body: fixture_file("events/list"), status: 200}
    stub(path: "scheduled_events?user=#{@user_uri}&organization=#{@organization_uri}", response: list_response)
    retrieve_response = {body: fixture_file("events/retrieve"), status: 200}
    stub(path: "scheduled_events/#{@event_uuid}", response: retrieve_response)
  end

  def test_list
    events = client.events.list(user: @user_uri, organization: @organization_uri)

    assert_equal Calendlyr::Collection, events.class
    assert_equal Calendlyr::Event, events.data.first.class
    assert_equal 1, events.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_list_from_user
    events = client.me.events

    assert_equal Calendlyr::Collection, events.class
    assert_equal Calendlyr::Event, events.data.first.class
    assert_equal 1, events.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_retrieve
    event = client.events.retrieve(uuid: @event_uuid)

    assert_equal Calendlyr::Event, event.class
    assert_equal "https://api.calendly.com/scheduled_events/GBGBDCAADAEDCRZ2", event.uri
    assert_equal "15 Minute Meeting", event.name
  end

  def test_list_with_bare_user_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/users/#{bare_uuid}"
    stub(path: "scheduled_events?user=#{expanded}", response: {body: fixture_file("events/list"), status: 200})

    events = client.events.list(user: bare_uuid)

    assert_equal Calendlyr::Collection, events.class
    assert_equal 1, events.data.count
  end

  def test_create_invitee
    body = {
      event_type: "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA",
      start_time: "2019-08-07T06:05:04.321123Z",
      invitee: {
        name: "John Doe",
        email: "test@example.com",
        timezone: "America/New_York"
      }
    }
    stub(method: :post, path: "invitees", response: {body: fixture_file("events/create_invitee"), status: 201})
    invitee = client.events.create_invitee(**body)

    assert_equal Calendlyr::Events::Invitee, invitee.class
    assert_equal "test@example.com", invitee.email
    assert_equal "John Doe", invitee.name
    assert_equal "active", invitee.status
  end

  def test_create_invitee_with_bare_event_type_uuid
    bare_uuid = "ET-456"
    expanded = "https://api.calendly.com/event_types/#{bare_uuid}"
    body = {
      event_type: expanded,
      start_time: "2019-08-07T06:05:04.321123Z",
      invitee: {name: "John Doe", email: "test@example.com", timezone: "America/New_York"}
    }
    stub(method: :post, path: "invitees", body: body, response: {body: fixture_file("events/create_invitee"), status: 201})

    invitee = client.events.create_invitee(
      event_type: bare_uuid,
      start_time: "2019-08-07T06:05:04.321123Z",
      invitee: {name: "John Doe", email: "test@example.com", timezone: "America/New_York"}
    )

    assert_equal Calendlyr::Events::Invitee, invitee.class
    assert_equal "test@example.com", invitee.email
  end

  def test_create_invitee_no_show_with_bare_invitee_uuid
    bare_uuid = "INV-789"
    expanded = "https://api.calendly.com/invitees/#{bare_uuid}"
    stub(method: :post, path: "invitee_no_shows", body: {invitee: expanded}, response: {body: fixture_file("events/create_invitee_no_show"), status: 201})

    no_show = client.events.create_invitee_no_show(invitee: bare_uuid)

    assert_equal Calendlyr::Events::InviteeNoShow, no_show.class
  end

  def test_list_all_returns_all_pages
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page2_path = "scheduled_events?user=#{@user_uri}&organization=#{@organization_uri}&page_token=#{token}"
    stub(path: page2_path, response: {body: fixture_file("events/list_page2"), status: 200})

    events = client.events.list_all(user: @user_uri, organization: @organization_uri)

    assert_equal Array, events.class
    assert_equal 2, events.size
    assert_equal Calendlyr::Event, events.first.class
  end

  def test_list_all_invitees_returns_all_pages
    event_uuid = "abc123"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_path = "scheduled_events/#{event_uuid}/invitees"
    page2_path = "scheduled_events/#{event_uuid}/invitees?page_token=#{token}"
    stub(path: page1_path, response: {body: fixture_file("event_invitees/list"), status: 200})
    stub(path: page2_path, response: {body: fixture_file("event_invitees/list_page2"), status: 200})

    invitees = client.events.list_all_invitees(uuid: event_uuid)

    assert_equal Array, invitees.class
    assert_equal 2, invitees.size
    assert_equal Calendlyr::Events::Invitee, invitees.first.class
  end
end
