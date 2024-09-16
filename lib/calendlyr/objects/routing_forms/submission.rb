module Calendlyr
  class RoutingForms::Submission < Object
    def associated_routing_form
      client.routing_forms.retrieve(uuid: get_slug(routing_form))
    end
  end
end
