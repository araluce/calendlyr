module Calendlyr
  class LocationsResource < Resource
    def list(**params)
      response = get_request("locations", params: params)
      Collection.from_response(response, type: Location, client: client)
    end
  end
end
