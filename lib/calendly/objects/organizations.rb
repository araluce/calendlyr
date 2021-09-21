module Calendly
  class Organization < Object
    def invite_user(email:)
      client.organizations.invite uuid: uuid, email: email
    end

    def list_invitations(**params)
      client.organizations.list_invitations organization_uuid: uuid, **params
    end

    def revoke_invitation(invitation_uuid:)
      client.organizations.revoke_invitation(organization_uuid: uuid, invitation_uuid: invitation_uuid)
    end

    def invitation(invitation_uuid:)
      client.organizations.retrieve_invitation(organization_uuid: uuid, invitation_uuid: invitation_uuid)
    end

    def events(**params)
      client.events.list user_uri: nil, organization_uri: uri, **params
    end

    def memberships(user_uri: nil, **params)
      client.organizations.list_memberships user_uri: user_uri, organization_uri: uri, **params
    end
  end
end
