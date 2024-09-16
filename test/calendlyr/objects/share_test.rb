# frozen_string_literal: true

require "test_helper"

class ShareObjectTest < Minitest::Test
  def test_associated_scheduling_links
    json = JSON.parse(fixture_file("objects/share")).merge(client: client)
    @share = Calendlyr::Share.new(json)

    response = {body: fixture_file("event_types/retrieve"), status: 200}
    stub(path: "event_types/AAAAAAAAAAAAAAAA", response: response)

    scheculing_links = @share.associated_scheduling_links

    assert_equal 1, scheculing_links.size
    assert_equal Calendlyr::SchedulingLink, scheculing_links.first.class
    assert_equal Calendlyr::EventType, scheculing_links.first.event_type.class
  end
end
