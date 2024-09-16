module Calendlyr
  class Organizations::Invitation < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def associated_user
      client.users.retrieve(uuid: get_slug(user))
    end

    def revoke
      associated_organization.revoke_invitation(invitation_uuid: uuid)
    end
  end
end
