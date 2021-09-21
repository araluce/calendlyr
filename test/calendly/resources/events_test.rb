# frozen_string_literal: true

require "test_helper"

class EventsResourceTest < Minitest::Test
  def test_list
    user_uri = "https://api.calendly.com/users/AAAAAAAAAAAAAAAA"
    organization_uri = "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA"
    stub = stub_request("scheduled_events?user=#{user_uri}&organization=#{organization_uri}", response: stub_response(fixture: "events/list"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    events = client.events.list(user_uri: user_uri, organization_uri: organization_uri)

    assert_equal Calendly::Collection, events.class
    assert_equal Calendly::Event, events.data.first.class
    assert_equal 1, events.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", events.next_page_token
  end

  def test_retrieve
    event_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("scheduled_events/#{event_uuid}", response: stub_response(fixture: "events/retrieve"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    event = client.events.retrieve(event_uuid: event_uuid)

    assert_equal Calendly::Event, event.class
    assert_equal "https://api.calendly.com/scheduled_events/GBGBDCAADAEDCRZ2", event.uri
    assert_equal "15 Minute Meeting", event.name
  end
end
