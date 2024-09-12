module Calendlyr
  class Organization < Object
    def activity_logs(**params)
      client.organizations.activity_log(**params.merge(organization: uri))
    end

    def events(**params)
      client.events.list(**params.merge(organization: uri))
    end

    def event_types(**params)
      client.event_types.list(**params.merge(organization: uri))
    end

    def routing_forms(**params)
      client.routing_forms.list(**params.merge(organization: uri))
    end

    # Groups
    def groups(**params)
      client.groups.list(**params.merge(organization: uri))
    end

    def group_relationships(**params)
      client.groups.list_relationships(**params.merge(organization: uri))
    end

    # Memberships
    def memberships(**params)
      client.organizations.list_memberships(**params.merge(organization: uri))
    end

    def membership(uuid:)
      client.organizations.retrieve_membership(uuid: uuid)
    end

    # Webhooks
    def webhooks(scope:, **params)
      client.webhooks.list(**params.merge(organization: uri, scope: scope))
    end

    def create_webhook(**params)
      client.webhooks.create(**params.merge(organization: uri))
    end

    def sample_webhook_data(event:, scope:, **params)
      client.webhooks.sample_webhook_data(event: event, scope: scope, organization: uri, **params)
    end

    # Invitations
    def invite_user(email:, **params)
      client.organizations.invite(**params.merge(organization_uuid: uuid, email: email))
    end

    def invitations(**params)
      client.organizations.list_invitations(**params.merge(uuid: uuid))
    end

    def invitation(invitation_uuid:)
      client.organizations.retrieve_invitation(org_uuid: uuid, uuid: invitation_uuid)
    end

    def revoke_invitation(invitation_uuid:)
      client.organizations.revoke_invitation(organization_uuid: uuid, invitation_uuid: invitation_uuid)
    end
  end
end
