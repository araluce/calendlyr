module Calendlyr
  class DataComplianceResource < Resource
    def delete_invitee_data(emails:)
      post_request("data_compliance/deletion/invitees", body: {emails: emails})
    end

    def delete_scheduled_event_data(start_time:, end_time:)
      post_request("data_compliance/deletion/events", body: {start_time: start_time, end_time: end_time})
    end
  end
end
