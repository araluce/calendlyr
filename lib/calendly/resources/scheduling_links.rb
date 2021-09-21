module Calendly
  class SchedulingLinkResource < Resource
    def create(owner_uri:, max_event_count:, owner_type: "EventType", **attributes)
      body = { owner: owner_uri, max_event_count: max_event_count, owner_type: owner_type }.merge(attributes).compact
      response = post_request("scheduling_links", body: body).body.dig("resource")
      SchedulingLink.new response, client: client
    end
  end
end
