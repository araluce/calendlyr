module Calendly
  class OrganizationResource < Resource
    def invite(organization_uuid:, email:)
      Invitation.new post_request("organizations/#{organization_uuid}/invitations", body: { email: email }).body, client: client
    end

    def list_invitations(organization_uuid:, **params)
      response = get_request("organizations/#{organization_uuid}/invitations", params: params)
      Collection.from_response(response, key: "collection", type: Invitation, client: client)
    end

    def list_memberships(user_uri: nil, organization_uri: nil, **params)
      response = get_request("organization_memberships", params: { user: user_uri, organization: organization_uri }.merge(params).compact)
      Collection.from_response(response, key: "collection", type: Membership, client: client)
    end

    def retrieve_invitation(organization_uuid:, invitation_uuid:)
      Invitation.new get_request("organizations/#{organization_uuid}/invitations/#{invitation_uuid}").body.dig("resource"), client: client
    end

    def retrieve_membership(membership_uuid:)
      Membership.new get_request("organization_memberships/#{membership_uuid}").body.dig("resource"), client: client
    end

    def revoke_invitation(organization_uuid:, invitation_uuid:)
      delete_request("organizations/#{organization_uuid}/invitations/#{invitation_uuid}")
    end

    def remove_user(membership_uuid:)
      delete_request("organization_memberships/#{membership_uuid}")
    end
  end
end
