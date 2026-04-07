# frozen_string_literal: true

require "test_helper"

class SchedulingLinksResourceTest < Minitest::Test
  def test_create
    event_type_uri = "https://api.calendly.com/event_types/GBGBDCAADAEDCRZ2"
    body = {max_event_count: 1, owner: event_type_uri, owner_type: "EventType"}
    stub(method: :post, path: "scheduling_links", body: body, response: {body: fixture_file("scheduling_links/create"), status: 201})

    link = client.scheduling_links.create(owner: event_type_uri)

    assert_equal Calendlyr::SchedulingLink, link.class
    assert_equal "https://calendly.com/d/abcd-brv8/15-minute-meeting", link.booking_url
    assert_equal event_type_uri, link.owner
    assert_equal "EventType", link.owner_type
  end

  def test_create_with_bare_event_type_uuid
    bare_uuid = "GBGBDCAADAEDCRZ2"
    expanded = "https://api.calendly.com/event_types/#{bare_uuid}"
    body = {max_event_count: 1, owner: expanded, owner_type: "EventType"}
    stub(method: :post, path: "scheduling_links", body: body, response: {body: fixture_file("scheduling_links/create"), status: 201})

    link = client.scheduling_links.create(owner: bare_uuid)

    assert_equal Calendlyr::SchedulingLink, link.class
    assert_equal "https://calendly.com/d/abcd-brv8/15-minute-meeting", link.booking_url
  end

  def test_create_with_custom_max_event_count
    event_type_uri = "https://api.calendly.com/event_types/GBGBDCAADAEDCRZ2"
    body = {max_event_count: 5, owner: event_type_uri, owner_type: "EventType"}
    stub(method: :post, path: "scheduling_links", body: body, response: {body: fixture_file("scheduling_links/create"), status: 201})

    link = client.scheduling_links.create(owner: event_type_uri, max_event_count: 5)

    assert_equal Calendlyr::SchedulingLink, link.class
  end
end
