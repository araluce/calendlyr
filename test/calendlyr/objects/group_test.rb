# frozen_string_literal: true

require "test_helper"

class GroupObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/group")).merge(client: client)
    @group = Calendlyr::Group.new(json)

    @start_time = "2020-01-02T20:00:00.000000Z"
    @end_time = "2020-01-07T24:00:00.000000Z"

    group_uri = "https://api.calendly.com/groups/AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("events/list"), status: 200}
    stub(path: "scheduled_events?group=#{group_uri}", response: response)

    response = {body: fixture_file("group_relationships/list"), status: 200}
    stub(path: "group_relationships?group=#{group_uri}", response: response)
  end

  def test_associated_organization
    organization = @group.associated_organization

    assert_equal Calendlyr::Organization, organization.class
  end

  def test_events
    events = @group.events

    assert_equal 1, events.data.size
    assert_equal Calendlyr::Event, events.data.first.class
  end

  def test_group_relationships
    group_relationships = @group.group_relationships

    assert_equal 3, group_relationships.data.size
    assert_equal Calendlyr::Groups::Relationship, group_relationships.data.first.class
  end
end
