module Calendlyr
  class UserBusyTimeResource < Resource
    def list(user_uri:, start_time:, end_time:, **params)
      response = get_request("user_busy_times", params: {user: user_uri, start_time: start_time, end_time: end_time}.merge(params).compact)
      Collection.from_response(response, type: UserBusyTime, client: client)
    end
  end
end
