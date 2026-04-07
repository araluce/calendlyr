module Calendlyr
  class EventTypesResource < Resource
    def list(**params)
      next_page_caller = ->(page_token:) { list(**params, page_token: page_token) }
      params[:user] = expand_uri(params[:user], "users") if params[:user]
      params[:organization] = expand_uri(params[:organization], "organizations") if params[:organization]
      response = get_request("event_types", params: params)
      Collection.from_response(response, type: EventType, client: client, next_page_caller: next_page_caller)
    end

    def list_all(**params)
      list(**params).auto_paginate.to_a
    end

    def retrieve(uuid:)
      EventType.new get_request("event_types/#{uuid}").dig("resource").merge(client: client)
    end

    def create_one_off(name:, host:, duration:, date_setting:, location:, **params)
      body = { name: name, host: host, duration: duration, date_setting: date_setting, location: location }.merge(params)
      EventType.new post_request("one_off_event_types", body: body).dig("resource").merge(client: client)
    end

    def create(name:, duration:, pooling_type:, **params)
      body = { name: name, duration: duration, pooling_type: pooling_type }.merge(params)
      EventType.new post_request("event_types", body: body).dig("resource").merge(client: client)
    end

    def update(uuid:, **params)
      EventType.new patch_request("event_types/#{uuid}", body: params).dig("resource").merge(client: client)
    end

    # Availability Schedules
    def list_availability_schedules(event_type_uuid:, **params)
      next_page_caller = ->(page_token:) { list_availability_schedules(event_type_uuid: event_type_uuid, **params, page_token: page_token) }
      response = get_request("event_type_availability_schedules", params: { event_type_uuid: event_type_uuid }.merge(params))
      Collection.from_response(response, type: EventTypes::AvailabilitySchedule, client: client, next_page_caller: next_page_caller)
    end

    def list_all_availability_schedules(event_type_uuid:, **params)
      list_availability_schedules(event_type_uuid: event_type_uuid, **params).auto_paginate.to_a
    end

    def update_availability_schedule(event_type_uuid:, availability_schedules:, **params)
      body = { event_type_uuid: event_type_uuid, availability_schedules: availability_schedules }.merge(params)
      patch_request("event_type_availability_schedules", body: body)
    end

    # Available Times (no pagination — endpoint does not support it)
    def list_available_times(event_type:, start_time:, end_time:, **params)
      event_type = expand_uri(event_type, "event_types")
      response = get_request("event_type_available_times", params: { event_type: event_type, start_time: start_time, end_time: end_time }.merge(params))
      Collection.from_response(response, type: EventTypes::AvailableTime, client: client)
    end

    # Event Type Memberships
    def list_memberships(event_type:, **params)
      next_page_caller = ->(page_token:) { list_memberships(event_type: event_type, **params, page_token: page_token) }
      event_type = expand_uri(event_type, "event_types")
      response = get_request("event_type_memberships", params: { event_type: event_type }.merge(params))
      Collection.from_response(response, type: EventTypes::Membership, client: client, next_page_caller: next_page_caller)
    end

    def list_all_memberships(event_type:, **params)
      list_memberships(event_type: event_type, **params).auto_paginate.to_a
    end
  end
end
