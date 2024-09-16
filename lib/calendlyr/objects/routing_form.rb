module Calendlyr
  class RoutingForm < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end

    def submissions(**params)
      client.routing_forms.list_submissions(**params.merge(form: uri))
    end
  end
end
