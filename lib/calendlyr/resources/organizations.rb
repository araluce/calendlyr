module Calendlyr
  class OrganizationsResource < Resource
    def activity_log(organization: nil, **params)
      next_page_caller = ->(page_token:) { activity_log(organization: organization, **params, page_token: page_token) }
      organization = expand_uri(organization, "organizations")
      response = get_request("activity_log_entries", params: {organization: organization}.merge(params).compact)
      Collection.from_response(response, type: ActivityLog, client: client, next_page_caller: next_page_caller)
    end

    def list_all_activity_log(organization: nil, **params)
      activity_log(organization: organization, **params).auto_paginate.to_a
    end

    # Memberships
    def list_memberships(**params)
      next_page_caller = ->(page_token:) { list_memberships(**params, page_token: page_token) }
      params[:organization] = expand_uri(params[:organization], "organizations") if params[:organization]
      params[:user] = expand_uri(params[:user], "users") if params[:user]
      response = get_request("organization_memberships", params: params)
      Collection.from_response(response, type: Organizations::Membership, client: client, next_page_caller: next_page_caller)
    end

    def list_all_memberships(**params)
      list_memberships(**params).auto_paginate.to_a
    end

    def retrieve_membership(uuid:)
      Organizations::Membership.new(get_request("organization_memberships/#{uuid}").dig("resource").merge(client: client))
    end

    def remove_user(uuid:)
      delete_request("organization_memberships/#{uuid}")
    end

    # Invitations
    def list_invitations(uuid:, **params)
      next_page_caller = ->(page_token:) { list_invitations(uuid: uuid, **params, page_token: page_token) }
      response = get_request("organizations/#{uuid}/invitations", params: params)
      Collection.from_response(response, type: Organizations::Invitation, client: client, next_page_caller: next_page_caller)
    end

    def list_all_invitations(uuid:, **params)
      list_invitations(uuid: uuid, **params).auto_paginate.to_a
    end

    def retrieve_invitation(org_uuid:, uuid:)
      Organizations::Invitation.new get_request("organizations/#{org_uuid}/invitations/#{uuid}").dig("resource").merge(client: client)
    end

    def invite(organization_uuid:, email:)
      Organizations::Invitation.new post_request("organizations/#{organization_uuid}/invitations", body: {email: email}).dig("resource").merge(client: client)
    end

    def revoke_invitation(org_uuid:, uuid:)
      delete_request("organizations/#{org_uuid}/invitations/#{uuid}")
    end
  end
end
