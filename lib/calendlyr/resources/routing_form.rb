module Calendlyr
  class RoutingFormResource < Resource
    def list(organization:, **params)
      response = get_request("routing_forms", params: {organization: organization}.merge(params))
      Collection.from_response(response, type: RoutingForm, client: client)
    end

    def retrieve(uuid:)
      RoutingForm.new(get_request("routing_forms/#{uuid}").dig("resource").merge(client: client))
    end

    # Routing Form Submission
    def list_submissions(form:, **params)
      response = get_request("routing_form_submissions/", params: {form: form}.merge(params))
      Collection.from_response(response, type: RoutingForms::Submission, client: client)
    end

    def retrieve_submission(uuid:)
      RoutingForms::Submission.new get_request("routing_form_submissions/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
