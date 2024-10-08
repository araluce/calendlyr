# frozen_string_literal: true

require "test_helper"

module Availabilities
  class UserScheduleTest < Minitest::Test
    def setup
      @user_uri = "https://api.calendly.com/users/abc123"
      @uuid = "abc123"
      stub(path: "users/abc123", response: {body: fixture_file("users/retrieve"), status: 200})
      stub(path: "user_availability_schedules?user=#{@user_uri}", response: {body: fixture_file("user_availability_schedules/list"), status: 200})
      stub(path: "user_availability_schedules/#{@uuid}", response: {body: fixture_file("user_availability_schedules/retrieve"), status: 200})
    end

    def test_list
      user_availability_schedules = client.availability.list_user_schedules(user: @user_uri)

      assert_equal 2, user_availability_schedules.data.count
      assert_equal Calendlyr::Collection, user_availability_schedules.class
      assert_equal Calendlyr::Availabilities::UserSchedule, user_availability_schedules.data.first.class
    end

    def test_list_from_user
      availability_schedules = client.me.availability_schedules

      assert_equal Calendlyr::Collection, availability_schedules.class
      assert_equal Calendlyr::Availabilities::UserSchedule, availability_schedules.data.first.class
      assert_equal 2, availability_schedules.data.count
    end

    def test_retrieve
      user_availability_schedule = client.availability.retrieve_user_schedule(uuid: @uuid)

      assert_equal Calendlyr::Availabilities::UserSchedule, user_availability_schedule.class
    end
  end
end
