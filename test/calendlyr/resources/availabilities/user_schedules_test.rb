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

    def test_list_with_bare_user_uuid
      bare_uuid = "abc123"
      expanded = "https://api.calendly.com/users/#{bare_uuid}"
      stub(path: "user_availability_schedules?user=#{expanded}", response: {body: fixture_file("user_availability_schedules/list"), status: 200})

      schedules = client.availability.list_user_schedules(user: bare_uuid)

      assert_equal Calendlyr::Collection, schedules.class
      assert_equal 2, schedules.data.count
    end

    def test_list_all_user_schedules_returns_all_pages
      token = "PAGE2TOKEN"
      page1_response = {body: fixture_file("user_availability_schedules/list_page1"), status: 200}
      page2_response = {body: fixture_file("user_availability_schedules/list_page2"), status: 200}
      stub(path: "user_availability_schedules?user=#{@user_uri}", response: page1_response)
      stub(path: "user_availability_schedules?user=#{@user_uri}&page_token=#{token}", response: page2_response)

      schedules = client.availability.list_all_user_schedules(user: @user_uri)

      assert_equal Array, schedules.class
      assert_equal 2, schedules.size
      assert_equal Calendlyr::Availabilities::UserSchedule, schedules.first.class
    end
  end
end
