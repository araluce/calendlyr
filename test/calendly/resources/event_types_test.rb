# frozen_string_literal: true

require "test_helper"

class EventTypesResourceTest < Minitest::Test
  def test_list
    user_uri = "https://api.calendly.com/users/AAAAAAAAAAAAAAAA"
    organization_uri = "https://api.calendly.com/organizations/AAAAAAAAAAAAAAAA"
    stub = stub_request("event_types?user=#{user_uri}&organization=#{organization_uri}", response: stub_response(fixture: "event_types/list"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    event_types = client.event_types.list(user_uri: user_uri, organization_uri: organization_uri)

    assert_equal Calendly::Collection, event_types.class
    assert_equal Calendly::EventType, event_types.data.first.class
    assert_equal 1, event_types.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_retrieve
    event_type_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("event_types/#{event_type_uuid}", response: stub_response(fixture: "event_types/retrieve"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    event_type = client.event_types.retrieve(event_type_uuid: event_type_uuid)

    assert_equal Calendly::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "15 Minute Meeting", event_type.name
    assert_equal "acmesales", event_type.slug
    assert_equal 30, event_type.duration
  end
end
