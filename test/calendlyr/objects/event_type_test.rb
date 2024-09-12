# frozen_string_literal: true

require "test_helper"

class EventTypeObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/event_type")).merge(client: client)
    @event_type = Calendlyr::EventType.new(json)

    event_type_uri = "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA"
    @start_time = "2020-01-02T20:00:00.000000Z"
    @end_time = "2020-01-07T24:00:00.000000Z"

    response = {body: fixture_file("event_type_available_times/list"), status: 200}
    stub(path: "event_type_available_times?event_type=#{event_type_uri}&start_time=#{@start_time}&end_time=#{@end_time}", response: response)

    event_type_uri = "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("shares/create"), status: 201}
    stub(method: :post, path: "shares", body: {event_type: event_type_uri}, response: response)
  end

  def test_associated_profile
    profile = @event_type.associated_profile

    assert_equal Calendlyr::EventTypes::Profile, profile.class
    assert_equal "Tamara Jones", profile.name
  end

  def test_create_share
    share = @event_type.create_share

    assert_equal Calendlyr::Share, share.class
    assert_equal 1, share.scheduling_links.size
  end

  def test_available_times
    available_times = @event_type.available_times(start_time: @start_time, end_time: @end_time)

    assert 3, available_times.data.size
    assert "available", available_times.data.first.status
    assert Calendlyr::EventTypes::AvailableTime, available_times.data.first.class
  end
end
