# frozen_string_literal: true

require "test_helper"

class ScheduleLinkObjectTest < Minitest::Test
  def test_event_type
    json = JSON.parse(fixture_file("objects/scheduling_links/event_type")).merge(client: client)
    @scheduling_link = Calendlyr::SchedulingLink.new(json)

    response = {body: fixture_file("event_types/retrieve"), status: 200}
    stub(path: "event_types/GBGBDCAADAEDCRZ2", response: response)

    event_type = @scheduling_link.event_type

    assert_equal Calendlyr::EventType, event_type.class
  end
end
