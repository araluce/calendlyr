# frozen_string_literal: true

require "test_helper"

module Availabilities
  class UserScheduleObjectTest < Minitest::Test
    def setup
      stub(path: "users/abc123", response: {body: fixture_file("users/retrieve"), status: 200})
      json = JSON.parse(fixture_file("objects/availabilities/user_schedule")).merge(client: client)
      @user_availability_schedule = Calendlyr::Availabilities::UserSchedule.new(json)
    end

    def test_associated_user
      assert_equal Calendlyr::User, @user_availability_schedule.associated_user.class
    end

    def test_availability_schedule
      assert_equal "America\\/New_York", @user_availability_schedule.timezone
    end

    def test_availability_rules
      assert_equal 7, @user_availability_schedule.availability_rules.count
      assert_equal Calendlyr::Availabilities::Rule, @user_availability_schedule.availability_rules.first.class
    end
  end
end
