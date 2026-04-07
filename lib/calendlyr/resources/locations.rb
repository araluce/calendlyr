module Calendlyr
  class LocationsResource < Resource
    def list(**params)
      next_page_caller = ->(page_token:) { list(**params, page_token: page_token) }
      response = get_request("locations", params: params)
      Collection.from_response(response, type: Location, client: client, next_page_caller: next_page_caller)
    end

    def list_all(**params)
      list(**params).auto_paginate.to_a
    end
  end
end
