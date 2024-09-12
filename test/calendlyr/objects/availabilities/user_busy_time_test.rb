# frozen_string_literal: true

require "test_helper"
module Availabilities
  class UserBusyTimeObjectTest < Minitest::Test
    def setup
      response = {body: fixture_file("events/retrieve"), status: 200}
      stub(path: "scheduled_events/abc123", response: response)
      json = JSON.parse(fixture_file("objects/availabilities/user_busy_time")).merge(client: client)
      @user_busy_time = Calendlyr::Availabilities::UserBusyTime.new(json)
    end

    def test_associated_event
      assert_equal Calendlyr::Event, @user_busy_time.associated_event.class
    end

    def test_type
      assert_equal "calendly", @user_busy_time.type
    end
  end
end
