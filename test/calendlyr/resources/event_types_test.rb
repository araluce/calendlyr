# frozen_string_literal: true

require "test_helper"

class EventTypesResourceTest < Minitest::Test
  def setup
    @user_uri = "https://api.calendly.com/users/abc123"
    @organization_uri = "https://api.calendly.com/organizations/abc123"
    @event_type_uuid = "AAAAAAAAAAAAAAAA"
    list_response = {body: fixture_file("event_types/list"), status: 200}
    stub(path: "event_types?user=#{@user_uri}&organization=#{@organization_uri}", response: list_response)
    stub(path: "event_types?organization=#{@organization_uri}", response: list_response)
    stub(path: "event_types?user=#{@user_uri}", response: list_response)
    retrieve_response = {body: fixture_file("event_types/retrieve"), status: 200}
    stub(path: "event_types/#{@event_type_uuid}", response: retrieve_response)
  end

  def test_list
    event_types = client.event_types.list(user: @user_uri, organization: @organization_uri)

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal Calendlyr::EventType, event_types.data.first.class
    assert_equal 1, event_types.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_list_from_user
    event_types = client.me.event_types

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal Calendlyr::EventType, event_types.data.first.class
    assert_equal 1, event_types.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_retrieve
    event_type = client.event_types.retrieve(uuid: @event_type_uuid)

    assert_equal Calendlyr::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "15 Minute Meeting", event_type.name
    assert_equal "acmesales", event_type.slug
    assert_equal 30, event_type.duration
  end
end
