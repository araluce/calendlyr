# frozen_string_literal: true

require "test_helper"

module Organizations
  class InvitationObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/organizations/invitation")).merge(client: client)
      @invitation = Calendlyr::Organizations::Invitation.new(json)

      organization_uuid = "abc123"
      invitation_uuid = "BBBBBBBBBBBBBBBB"
      response = {body: fixture_file("organizations/revoke_invitation"), status: 204}
      stub(method: :delete, path: "organizations/#{organization_uuid}/invitations/#{invitation_uuid}", response: response)

      user_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/#{user_uuid}", response: response)
    end

    def test_associated_organization
      organization = @invitation.associated_organization

      assert_equal Calendlyr::Organization, organization.class
    end

    def test_associated_user
      user = @invitation.associated_user

      assert_equal "John Doe", user.name
    end

    def test_revoke
      assert @invitation.revoke
    end
  end
end
