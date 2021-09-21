module Calendly
  class Invitation < Object
    def associated_organization
      @associated_organization ||= Organization.new({ "uri" => organization }, client: client)
    end

    def revoke
      associated_organization.revoke_invitation invitation_uuid: uuid
    end
  end
end
