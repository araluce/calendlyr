# frozen_string_literal: true

require "test_helper"

class EventsResourceTest < Minitest::Test
  def test_list
    user_uri = "https://api.calendly.com/users/AAAAAAAAAAAAAAAA"
    organization_uri = "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("events/list"), status: 200}
    stub(path: "scheduled_events?user=#{user_uri}&organization=#{organization_uri}", response: response)
    events = client.events.list(user_uri: user_uri, organization_uri: organization_uri)

    assert_equal Calendlyr::Collection, events.class
    assert_equal Calendlyr::Event, events.data.first.class
    assert_equal 1, events.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_retrieve
    event_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("events/retrieve"), status: 200}
    stub(path: "scheduled_events/#{event_uuid}", response: response)
    event = client.events.retrieve(event_uuid: event_uuid)

    assert_equal Calendlyr::Event, event.class
    assert_equal "https://api.calendly.com/scheduled_events/GBGBDCAADAEDCRZ2", event.uri
    assert_equal "15 Minute Meeting", event.name
  end
end
