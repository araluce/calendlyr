module Calendlyr
  class DataComplianceResource < Resource
    def delete_invitee_data(emails:)
      post_request("data_compliance/deletion/invitees", body: {emails: emails})
    end
  end
end
