# frozen_string_literal: true

require "test_helper"

class SharesResourceTest < Minitest::Test
  def test_create_with_bare_event_type_uuid
    bare_uuid = "ET-99"
    expanded = "https://api.calendly.com/event_types/#{bare_uuid}"
    stub(method: :post, path: "shares", body: {event_type: expanded}, response: {body: fixture_file("shares/create"), status: 201})

    share = client.shares.create(event_type: bare_uuid)

    assert_equal Calendlyr::Share, share.class
  end
end
