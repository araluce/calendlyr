# frozen_string_literal: true

require "test_helper"

module EventTypes
  class AvailabilityScheduleObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/event_types/availability_schedule")).merge(client: client)
      @availability_schedule = Calendlyr::EventTypes::AvailabilitySchedule.new(json)
    end

    def test_uri
      assert_equal "https://api.calendly.com/event_type_availability_schedules/AAAAAAAAAAAAAAAA", @availability_schedule.uri
    end

    def test_event_type
      assert_equal "https://api.calendly.com/event_types/BBBBBBBBBBBBBBBB", @availability_schedule.event_type
    end
  end
end
