# frozen_string_literal: true

require "test_helper"

class SchedulingLinksResourceTest < Minitest::Test
  def test_create
    body = {owner_uri: "https://api.calendly.com/event_types/GBGBDCAADAEDCRZ2", max_event_count: 20, owner_type: "EventType"}
    stub(method: :post, path: "scheduling_links", body: body, response: {body: fixture_file("scheduling_links/create"), status: 201})

    assert client.data_compliance.delete_invitee_data(**body)
  end
end
