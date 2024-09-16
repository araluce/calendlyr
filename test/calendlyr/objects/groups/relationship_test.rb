# frozen_string_literal: true

require "test_helper"

module Groups
  class RelationshipObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/groups/relationship")).merge(client: client)
      @relationship = Calendlyr::Groups::Relationship.new(json)

      group_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("groups/retrieve"), status: 200}
      stub(path: "groups/#{group_uuid}", response: response)
    end

    def test_associated_organization
      organization = @relationship.associated_organization

      assert_equal Calendlyr::Organization, organization.class
    end

    def test_associated_group
      group = @relationship.associated_group

      assert_equal "Sales Team", group.name
    end

    def test_associated_owner
      organization_membership_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("organization_memberships/retrieve"), status: 200}
      stub(path: "organization_memberships/#{organization_membership_uuid}", response: response)

      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/AAAAAAAAAAAAAAAA", response: response)

      owner = @relationship.associated_owner

      assert_equal Calendlyr::Organizations::Membership, owner.class
      assert_equal Calendlyr::User, owner.associated_user.class
      assert_equal "John Doe", owner.associated_user.name
    end
  end
end
