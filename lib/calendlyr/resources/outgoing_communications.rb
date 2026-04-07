# frozen_string_literal: true

module Calendlyr
  class OutgoingCommunicationsResource < Resource
    def list(organization:, **params)
      next_page_caller = ->(page_token:) { list(organization: organization, **params, page_token: page_token) }
      organization = expand_uri(organization, "organizations")
      response = get_request("outgoing_communications", params: {organization: organization}.merge(params))
      Collection.from_response(response, type: OutgoingCommunication, client: client, next_page_caller: next_page_caller)
    end

    def list_all(organization:, **params)
      list(organization: organization, **params).auto_paginate.to_a
    end
  end
end
