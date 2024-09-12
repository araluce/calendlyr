# frozen_string_literal: true

require "test_helper"

module Availabilities
  class UserBusyTimeTest < Minitest::Test
    def setup
      @user_uri = "https://api.calendly.com/users/abc123"
      @start_time = "2020-01-02T20:00:00.000000Z"
      @end_time = "2020-01-02T20:30:00.000000Z"
      response = {body: fixture_file("user_busy_times/list"), status: 200}
      stub(path: "user_busy_times?user=#{@user_uri}&start_time=#{@start_time}&end_time=#{@end_time}", response: response)
    end

    def test_list
      user_busy_times = client.availability.list_user_busy_times(user: @user_uri, start_time: @start_time, end_time: @end_time)

      assert_equal Calendlyr::Collection, user_busy_times.class
      assert_equal Calendlyr::Availabilities::UserBusyTime, user_busy_times.data.first.class
      assert_equal 5, user_busy_times.data.count
    end

    def test_list_from_user
      user_busy_times = client.me.busy_times(start_time: @start_time, end_time: @end_time)

      assert_equal Calendlyr::Collection, user_busy_times.class
      assert_equal Calendlyr::Availabilities::UserBusyTime, user_busy_times.data.first.class
      assert_equal 5, user_busy_times.data.count
    end
  end
end
