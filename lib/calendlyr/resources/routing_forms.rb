module Calendlyr
  class RoutingFormsResource < Resource
    def list(organization:, **params)
      organization = expand_uri(organization, "organizations")
      response = get_request("routing_forms", params: {organization: organization}.merge(params))
      Collection.from_response(response, type: RoutingForm, client: client)
    end

    def retrieve(uuid:)
      RoutingForm.new(get_request("routing_forms/#{uuid}").dig("resource").merge(client: client))
    end

    # Routing Form Submission
    def list_submissions(form:, **params)
      form = expand_uri(form, "routing_forms")
      response = get_request("routing_form_submissions", params: {form: form}.merge(params))
      Collection.from_response(response, type: RoutingForms::Submission, client: client)
    end

    def retrieve_submission(uuid:)
      RoutingForms::Submission.new get_request("routing_form_submissions/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
