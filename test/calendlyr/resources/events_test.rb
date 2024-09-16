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
end
