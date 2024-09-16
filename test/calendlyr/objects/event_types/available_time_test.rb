# frozen_string_literal: true

require "test_helper"

module EventTypes
  class AvailableTimeObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/event_types/available_time")).merge(client: client)
      @available_time = Calendlyr::EventTypes::AvailableTime.new(json)
    end

    def test_status
      assert_equal "available", @available_time.status
    end

    def test_invitees_remaining
      assert_equal 2, @available_time.invitees_remaining
    end
  end
end
