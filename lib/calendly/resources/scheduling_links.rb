module Calendly
  class SchedulingLinkResource < Resource
    def create(owner_uri:, max_event_count:, owner_type: "EventType")
      body = {owner: owner_uri, max_event_count: max_event_count, owner_type: owner_type}
      SchedulingLink.new post_request("scheduling_links", body: body).dig("resource").merge(client: client)
    end
  end
end
