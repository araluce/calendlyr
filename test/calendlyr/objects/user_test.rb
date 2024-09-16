# frozen_string_literal: true

require "test_helper"

class UserObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/user")).merge(client: client)
    @user = Calendlyr::User.new(json)

    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{@user.uuid}", response: response)
  end

  def test_organization
    organization = @user.organization

    assert_equal Calendlyr::Organization, organization.class
  end

  def test_availability_schedules
    response = {body: fixture_file("availabilities/user_schedules_list"), status: 200}
    stub(path: "user_availability_schedules?user=#{@user.uri}", response: response)

    availability_schedules = @user.availability_schedules

    assert_equal 2, availability_schedules.data.size
    assert_equal Calendlyr::Availabilities::UserSchedule, availability_schedules.data.first.class
  end

  def test_event_types
    response = {body: fixture_file("event_types/list"), status: 200}
    stub(path: "event_types?user=#{@user.uri}", response: response)

    event_types = @user.event_types

    assert_equal 1, event_types.data.size
    assert_equal Calendlyr::EventType, event_types.data.first.class
  end

  def test_events
    response = {body: fixture_file("events/list"), status: 200}
    stub(path: "scheduled_events?user=#{@user.uri}&organization=#{@user.current_organization}", response: response)

    events = @user.events

    assert_equal 1, events.data.size
    assert_equal Calendlyr::Event, events.data.first.class
  end

  def test_memberships
    response = {body: fixture_file("organization_memberships/list"), status: 200}
    stub(path: "organization_memberships?user=#{@user.uri}&organization=#{@user.organization.uri}", response: response)

    memberships = @user.memberships

    assert_equal 1, memberships.data.size
    assert_equal Calendlyr::Organizations::Membership, memberships.data.first.class
  end

  def test_membership
    response = {body: fixture_file("organization_memberships/retrieve"), status: 200}
    stub(path: "organization_memberships/AAAAAAAAAAAAAAAA", response: response)

    membership = @user.membership(uuid: "AAAAAAAAAAAAAAAA")

    assert_equal Calendlyr::User, membership.associated_user.class
    assert_equal Calendlyr::Organizations::Membership, membership.class
  end

  def test_busy_times
    start_time = "2020-01-02T20:00:00.000000Z"
    end_time = "2020-01-07T24:00:00.000000Z"
    response = {body: fixture_file("availabilities/user_busy_times_list"), status: 200}
    stub(path: "user_busy_times?user=#{@user.uri}&start_time=#{start_time}&end_time=#{end_time}", response: response)

    busy_times = @user.busy_times(start_time: start_time, end_time: end_time)

    assert_equal 5, busy_times.data.size
    assert_equal Calendlyr::Availabilities::UserBusyTime, busy_times.data.first.class
  end
end
