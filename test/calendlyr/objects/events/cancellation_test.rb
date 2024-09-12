# frozen_string_literal: true

require "test_helper"

module Events
  class CancellationObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/events/cancellation")).merge(client: client)
      @cancellation = Calendlyr::Events::Cancellation.new(json)
    end

    def test_canceled_by
      assert "string", @cancellation.canceled_by
    end
  end
end
