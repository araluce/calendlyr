module Calendlyr
  class SharesResource < Resource
    def create(event_type:, **params)
      event_type = expand_uri(event_type, "event_types")
      body = {event_type: event_type}.merge(params)
      Share.new post_request("shares", body: body).dig("resource").merge(client: client)
    end
  end
end
