module Calendlyr
  class UserAvailabilityScheduleResource < Resource
    def list(user_uri:, **params)
      response = get_request("user_availability_schedules", params: {user: user_uri}.merge(params).compact)
      Collection.from_response(response, type: UserAvailabilitySchedule, client: client)
    end

    def retrieve(uuid:)
      UserAvailabilitySchedule.new get_request("user_availability_schedules/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
