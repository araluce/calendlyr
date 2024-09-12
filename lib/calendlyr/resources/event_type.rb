module Calendlyr
  class EventTypeResource < Resource
    def list(**params)
      response = get_request("event_types", params: params)
      Collection.from_response(response, type: EventType, client: client)
    end

    def retrieve(uuid:)
      EventType.new get_request("event_types/#{uuid}").dig("resource").merge(client: client)
    end

    def create_one_off(name:, host:, duration:, date_setting:, location:, **params)
      body = {name: name, host: host, duration: duration, date_setting: date_setting, location: location}.merge(params)
      EventType.new post_request("one_off_event_types", body: body).dig("resource").merge(client: client)
    end

    def list_memberships(event_type:, **params)
      response = get_request("event_type_memberships", params: {event_type: event_type}.merge(params))
      Collection.from_response(response, type: EventTypes::Membership, client: client)
    end

    # Available Times
    def list_available_times(event_type:, start_time:, end_time:,**params)
      response = get_request("event_type_available_times", params: { event_type: event_type, start_time: start_time, end_time: end_time }.merge(params))
      Collection.from_response(response, type: EventTypes::AvailableTime, client: client)
    end
  end
end
