# frozen_string_literal: true

module Calendlyr
  class SchedulingLinksResource < Resource
    def create(owner:, owner_type: "EventType", max_event_count: 1)
      owner = expand_uri(owner, "event_types")
      body = {max_event_count: max_event_count, owner: owner, owner_type: owner_type}
      SchedulingLink.new post_request("scheduling_links", body: body).dig("resource").merge(client: client)
    end
  end
end
