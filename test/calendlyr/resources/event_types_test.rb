# frozen_string_literal: true

require "test_helper"

class EventTypesResourceTest < Minitest::Test
  def setup
    @user_uri = "https://api.calendly.com/users/abc123"
    @organization_uri = "https://api.calendly.com/organizations/abc123"
    @event_type_uuid = "AAAAAAAAAAAAAAAA"
    list_response = {body: fixture_file("event_types/list"), status: 200}
    stub(path: "event_types?user=#{@user_uri}&organization=#{@organization_uri}", response: list_response)
    stub(path: "event_types?organization=#{@organization_uri}", response: list_response)
    stub(path: "event_types?user=#{@user_uri}", response: list_response)
    retrieve_response = {body: fixture_file("event_types/retrieve"), status: 200}
    stub(path: "event_types/#{@event_type_uuid}", response: retrieve_response)
  end

  def test_list
    event_types = client.event_types.list(user: @user_uri, organization: @organization_uri)

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal Calendlyr::EventType, event_types.data.first.class
    assert_equal 1, event_types.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_list_from_user
    event_types = client.me.event_types

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal Calendlyr::EventType, event_types.data.first.class
    assert_equal 1, event_types.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_types.next_page_token
  end

  def test_retrieve
    event_type = client.event_types.retrieve(uuid: @event_type_uuid)

    assert_equal Calendlyr::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "15 Minute Meeting", event_type.name
    assert_equal "acmesales", event_type.slug
    assert_equal 30, event_type.duration
  end

  def test_create_one_off
    body = {
      name: "My Meeting",
      host: "https://api.calendly.com/users/AAAAAAAAAAAAAAAA",
      co_hosts: [
        "https://api.calendly.com/users/BBBBBBBBBBBBBBBB",
        "https://api.calendly.com/users/CCCCCCCCCCCCCCCC"
      ],
      duration: 30,
      timezone: "string",
      date_setting: {
        type: "date_range",
        start_date: "2020-01-07",
        end_date: "2020-01-09"
      },
      location: {
        kind: "physical",
        location: "Main Office",
        additonal_info: "string"
      }
    }
    stub(method: :post, path: "one_off_event_types", response: {body: fixture_file("event_types/create_one_off"), status: 201})
    event_type = client.event_types.create_one_off(**body)

    assert_equal Calendlyr::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "15 Minute Meeting", event_type.name
    assert_equal "acmesales", event_type.slug
    assert_equal 30, event_type.duration
  end

  def test_create
    body = {
      name: "30 Minute Meeting",
      duration: 30,
      pooling_type: "round_robin"
    }
    stub(method: :post, path: "event_types", response: {body: fixture_file("event_types/create"), status: 201})
    event_type = client.event_types.create(**body)

    assert_equal Calendlyr::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "30 Minute Meeting", event_type.name
    assert_equal 30, event_type.duration
  end

  def test_update
    stub(method: :patch, path: "event_types/#{@event_type_uuid}", response: {body: fixture_file("event_types/update"), status: 200})
    event_type = client.event_types.update(uuid: @event_type_uuid, name: "Updated Meeting", duration: 45)

    assert_equal Calendlyr::EventType, event_type.class
    assert_equal "https://api.calendly.com/event_types/AAAAAAAAAAAAAAAA", event_type.uri
    assert_equal "Updated Meeting", event_type.name
    assert_equal 45, event_type.duration
  end

  def test_list_with_bare_user_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/users/#{bare_uuid}"
    stub(path: "event_types?user=#{expanded}", response: {body: fixture_file("event_types/list"), status: 200})

    event_types = client.event_types.list(user: bare_uuid)

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal 1, event_types.data.count
  end

  def test_list_with_bare_org_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    stub(path: "event_types?organization=#{expanded}", response: {body: fixture_file("event_types/list"), status: 200})

    event_types = client.event_types.list(organization: bare_uuid)

    assert_equal Calendlyr::Collection, event_types.class
    assert_equal 1, event_types.data.count
  end

  def test_list_availability_schedules
    stub(path: "event_type_availability_schedules?event_type_uuid=AAAAAAAAAAAAAAAA", response: {body: fixture_file("event_type_availability_schedules/list"), status: 200})
    schedules = client.event_types.list_availability_schedules(event_type_uuid: "AAAAAAAAAAAAAAAA")

    assert_equal Calendlyr::Collection, schedules.class
    assert_equal Calendlyr::EventTypes::AvailabilitySchedule, schedules.data.first.class
    assert_equal 1, schedules.data.count
  end

  def test_update_availability_schedule
    body = {
      event_type_uuid: "AAAAAAAAAAAAAAAA",
      availability_schedules: [
        {start_time: "2023-10-27T09:00:00Z", end_time: "2023-10-27T12:00:00Z"}
      ]
    }
    stub(method: :patch, path: "event_type_availability_schedules", response: {body: fixture_file("event_type_availability_schedules/update"), status: 200})
    result = client.event_types.update_availability_schedule(**body)

    assert result
    assert_equal "Availability schedules updated successfully.", result["message"]
  end
end
