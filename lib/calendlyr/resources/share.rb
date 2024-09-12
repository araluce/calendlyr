module Calendlyr
  class ShareResource < Resource
    def create(event_type:, **params)
      body = { event_type: event_type }.merge(params)
      Share.new post_request("shares", body: body).dig("resource").merge(client: client)
    end
  end
end
