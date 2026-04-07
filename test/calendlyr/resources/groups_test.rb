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

  def test_list_with_bare_org_uuid
    bare_uuid = "AAAAAAAAAAAAAAAA"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    response = {body: fixture_file("groups/list"), status: 200}
    stub(path: "groups?organization=#{expanded}", response: response)

    groups = client.groups.list(organization: bare_uuid)

    assert_equal 1, groups.data.size
    assert_instance_of Calendlyr::Group, groups.data.first
  end

  def test_list_relationships_with_bare_org_uuid
    bare_uuid = "AAAAAAAAAAAAAAAA"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    response = {body: fixture_file("group_relationships/list"), status: 200}
    stub(path: "group_relationships?organization=#{expanded}", response: response)

    relationships = client.groups.list_relationships(organization: bare_uuid)

    assert_equal Calendlyr::Collection, relationships.class
  end

  def test_retrieve
    uuid = "abc123"
    response = {body: fixture_file("group_relationships/retrieve"), status: 200}
    stub(path: "group_relationships/#{uuid}", response: response)
    relationship = client.groups.retrieve_relationship(uuid: uuid)

    assert_instance_of Calendlyr::Groups::Relationship, relationship
    assert_equal "member", relationship.role
  end

  def test_list_all_returns_all_pages
    organization = "https://api.calendly.com/groups/AAAAAAAAAAAAAAAA"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("groups/list"), status: 200}
    page2_response = {body: fixture_file("groups/list_page2"), status: 200}
    stub(path: "groups?organization=#{organization}", response: page1_response)
    stub(path: "groups?organization=#{organization}&page_token=#{token}", response: page2_response)

    groups = client.groups.list_all(organization: organization)

    assert_equal Array, groups.class
    assert_equal 2, groups.size
    assert_equal Calendlyr::Group, groups.first.class
  end

  def test_list_all_relationships_returns_all_pages
    bare_uuid = "AAAAAAAAAAAAAAAA"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page1_response = {body: fixture_file("group_relationships/list"), status: 200}
    page2_response = {body: fixture_file("group_relationships/list_page2"), status: 200}
    stub(path: "group_relationships?organization=#{expanded}", response: page1_response)
    stub(path: "group_relationships?organization=#{expanded}&page_token=#{token}", response: page2_response)

    relationships = client.groups.list_all_relationships(organization: bare_uuid)

    assert_equal Array, relationships.class
    assert_equal 4, relationships.size
    assert_equal Calendlyr::Groups::Relationship, relationships.first.class
  end
end
