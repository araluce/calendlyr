module Calendlyr
  class RoutingForm < Object
    def associated_organization
      Organization.new({"uri" => organization}.merge(client: client))
    end
  end
end
