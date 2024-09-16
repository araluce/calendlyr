# frozen_string_literal: true

require "test_helper"

module Webhooks
  class PayloadObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/webhooks/payload")).merge(client: client)
      @payload = Calendlyr::Webhooks::Payload.new(json)
    end

    def test_event
      assert_equal "invitee.created", @payload.event
    end
  end
end
