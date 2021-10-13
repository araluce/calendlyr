# frozen_string_literal: true

require "test_helper"

class SchedulingLinksResourceTest < Minitest::Test
  def test_create
    owner_uri = "https://api.calendly.com/event_types/GBGBDCAADAEDCRZ2"
    max_event_count = 20
    owner_type = "EventType"
    response = {body: fixture_file("scheduling_links/create"), status: 201}
    stub(method: :post, path: "scheduling_links", body: {owner: owner_uri, max_event_count: max_event_count, owner_type: owner_type}, response: response)

    assert client.scheduling_links.create(owner_uri: owner_uri, max_event_count: max_event_count, owner_type: owner_type)
  end
end
