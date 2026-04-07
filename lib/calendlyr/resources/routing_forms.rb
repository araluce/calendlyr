module Calendlyr
  class RoutingFormsResource < Resource
    def list(organization:, **params)
      next_page_caller = ->(page_token:) { list(organization: organization, **params, page_token: page_token) }
      organization = expand_uri(organization, "organizations")
      response = get_request("routing_forms", params: {organization: organization}.merge(params))
      Collection.from_response(response, type: RoutingForm, client: client, next_page_caller: next_page_caller)
    end

    def list_all(organization:, **params)
      list(organization: organization, **params).auto_paginate.to_a
    end

    def retrieve(uuid:)
      RoutingForm.new(get_request("routing_forms/#{uuid}").dig("resource").merge(client: client))
    end

    # Routing Form Submission
    def list_submissions(form:, **params)
      next_page_caller = ->(page_token:) { list_submissions(form: form, **params, page_token: page_token) }
      form = expand_uri(form, "routing_forms")
      response = get_request("routing_form_submissions", params: {form: form}.merge(params))
      Collection.from_response(response, type: RoutingForms::Submission, client: client, next_page_caller: next_page_caller)
    end

    def list_all_submissions(form:, **params)
      list_submissions(form: form, **params).auto_paginate.to_a
    end

    def retrieve_submission(uuid:)
      RoutingForms::Submission.new get_request("routing_form_submissions/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
