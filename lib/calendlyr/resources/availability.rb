module Calendlyr
  class AvailabilityResource < Resource
    # User Busy Time
    def list_user_busy_times(user:, start_time:, end_time:, **params)
      response = get_request("user_busy_times", params: {user: user, start_time: start_time, end_time: end_time}.merge(params).compact)
      Collection.from_response(response, type: Availabilities::UserBusyTime, client: client)
    end

    # User Schedule
    def list_user_schedules(user:, **params)
      response = get_request("user_availability_schedules", params: {user: user}.merge(params).compact)
      Collection.from_response(response, type: Availabilities::UserSchedule, client: client)
    end

    def retrieve_user_schedule(uuid:)
      Availabilities::UserSchedule.new get_request("user_availability_schedules/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
