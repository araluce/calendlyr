module Calendlyr
  class AvailabilityResource < Resource
    # User Busy Time
    def list_user_busy_times(user:, start_time:, end_time:, **params)
      next_page_caller = ->(page_token:) { list_user_busy_times(user: user, start_time: start_time, end_time: end_time, **params, page_token: page_token) }
      user = expand_uri(user, "users")
      response = get_request("user_busy_times", params: {user: user, start_time: start_time, end_time: end_time}.merge(params).compact)
      Collection.from_response(response, type: Availabilities::UserBusyTime, client: client, next_page_caller: next_page_caller)
    end

    def list_all_user_busy_times(user:, start_time:, end_time:, **params)
      list_user_busy_times(user: user, start_time: start_time, end_time: end_time, **params).auto_paginate.to_a
    end

    # User Schedule
    def list_user_schedules(user:, **params)
      next_page_caller = ->(page_token:) { list_user_schedules(user: user, **params, page_token: page_token) }
      user = expand_uri(user, "users")
      response = get_request("user_availability_schedules", params: {user: user}.merge(params).compact)
      Collection.from_response(response, type: Availabilities::UserSchedule, client: client, next_page_caller: next_page_caller)
    end

    def list_all_user_schedules(user:, **params)
      list_user_schedules(user: user, **params).auto_paginate.to_a
    end

    def retrieve_user_schedule(uuid:)
      Availabilities::UserSchedule.new get_request("user_availability_schedules/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
