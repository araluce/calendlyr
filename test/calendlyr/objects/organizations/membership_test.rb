# frozen_string_literal: true

require "test_helper"

module Organizations
  class MembershipObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/organizations/membership")).merge(client: client)
      @membership = Calendlyr::Organizations::Membership.new(json)

      owner_uri = "https://api.calendly.com/organization_memberships/AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("group_relationships/list"), status: 200}
      stub(path: "group_relationships?owner=#{owner_uri}", response: response)

      user_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/#{user_uuid}", response: response)
    end

    def test_associated_organization
      organization = @membership.associated_organization

      assert_equal Calendlyr::Organization, organization.class
    end

    def test_associated_user
      user = @membership.associated_user

      assert_equal "John Doe", user.name
    end

    def test_group_relationships
      group_relationships = @membership.group_relationships

      assert_equal Calendlyr::Groups::Relationship, group_relationships.data.first.class
    end
  end
end
