module Calendlyr
  class GroupsResource < Resource
    def list(organization:, **params)
      next_page_caller = ->(page_token:) { list(organization: organization, **params, page_token: page_token) }
      organization = expand_uri(organization, "organizations")
      response = get_request("groups", params: params.merge(organization: organization))
      Collection.from_response(response, type: Group, client: client, next_page_caller: next_page_caller)
    end

    def list_all(organization:, **params)
      list(organization: organization, **params).auto_paginate.to_a
    end

    def retrieve(uuid:)
      Group.new get_request("groups/#{uuid}").dig("resource").merge(client: client)
    end

    # Relationships
    def list_relationships(**params)
      next_page_caller = ->(page_token:) { list_relationships(**params, page_token: page_token) }
      params[:organization] = expand_uri(params[:organization], "organizations") if params[:organization]
      response = get_request("group_relationships", params: params)
      Collection.from_response(response, type: Groups::Relationship, client: client, next_page_caller: next_page_caller)
    end

    def list_all_relationships(**params)
      list_relationships(**params).auto_paginate.to_a
    end

    def retrieve_relationship(uuid:)
      Groups::Relationship.new get_request("group_relationships/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
