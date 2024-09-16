# frozen_string_literal: true

require "test_helper"

class GroupsResourceTest < Minitest::Test
  def test_list
    organization = "https://api.calendly.com/groups/AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("groups/list"), status: 200}
    stub(path: "groups?organization=#{organization}", response: response)

    groups = client.groups.list(organization: organization)

    assert_equal 1, groups.data.size
    assert_instance_of Calendlyr::Group, groups.data.first
  end

  def test_retrieve
    uuid = "abc123"
    response = {body: fixture_file("group_relationships/retrieve"), status: 200}
    stub(path: "group_relationships/#{uuid}", response: response)
    relationship = client.groups.retrieve_relationship(uuid: uuid)

    assert_instance_of Calendlyr::Groups::Relationship, relationship
    assert_equal "member", relationship.role
  end
end
