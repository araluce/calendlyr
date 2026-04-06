# frozen_string_literal: true

require "test_helper"

class EventTypeObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/event_type")).merge(client: client)
    @event_type = Calendlyr::EventType.new(json)

    event_type_uri = "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA"
    response = { body: fixture_file("shares/create"), status: 201 }
    stub(method: :post, path: "shares", body: { event_type: event_type_uri }, response: response)
  end

  def test_associated_profile
    profile = @event_type.associated_profile

    assert_equal Calendlyr::EventTypes::Profile, profile.class
    assert_equal "Tamara Jones", profile.name
  end

  def test_create_share
    share = @event_type.create_share

    assert_instance_of Calendlyr::Share, share
    assert_equal 1, share.scheduling_links.size
  end
end
