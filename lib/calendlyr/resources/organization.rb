module Calendlyr
  class OrganizationResource < Resource
    def activity_log(organization: nil, **params)
      response = get_request("activity_log_entries", params: {organization: organization}.merge(params).compact)
      Collection.from_response(response, type: ActivityLog, client: client)
    end

    # Memberships
    def list_memberships(**params)
      response = get_request("organization_memberships", params: params)
      Collection.from_response(response, type: Organizations::Membership, client: client)
    end

    def retrieve_membership(uuid:)
      Organizations::Membership.new(get_request("organization_memberships/#{uuid}").dig("resource").merge(client: client))
    end

    def remove_user(uuid:)
      delete_request("organization_memberships/#{uuid}")
    end

    # Invitations
    def list_invitations(uuid:, **params)
      response = get_request("organizations/#{uuid}/invitations", params: params)
      Collection.from_response(response, type: Organizations::Invitation, client: client)
    end

    def retrieve_invitation(org_uuid:, uuid:)
      Organizations::Invitation.new get_request("organizations/#{org_uuid}/invitations/#{uuid}").dig("resource").merge(client: client)
    end

    def invite(organization_uuid:, email:)
      Organizations::Invitation.new post_request("organizations/#{organization_uuid}/invitations", body: {email: email}).dig("resource").merge(client: client)
    end

    def revoke_invitation(organization_uuid:, invitation_uuid:)
      delete_request("organizations/#{organization_uuid}/invitations/#{invitation_uuid}")
    end
  end
end
