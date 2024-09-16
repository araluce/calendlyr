module Calendlyr
  class OutgoingCommunicationResource < Resource
    def list(**params)
      response = get_request("outgoing_communications", params: params)
      Collection.from_response(response, type: Object, client: client)
    end
  end
end
