module Calendlyr
  class Invitation < Object
    def associated_organization
      @associated_organization ||= Organization.new({"uri" => organization}.merge(client: client))
    end

    def revoke
      associated_organization.revoke_invitation invitation_uuid: uuid
    end
  end
end
