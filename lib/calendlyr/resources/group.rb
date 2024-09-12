module Calendlyr
  class GroupResource < Resource
    def list(organization:, **params)
      response = get_request("groups", params: params.merge(organization: organization))
      Collection.from_response(response, type: Group, client: client)
    end

    def retrieve(group_uuid:)
      Group.new get_request("groups/#{group_uuid}").dig("resource").merge(client: client)
    end

    # Relationships
    def list_relationships(**params)
      response = get_request("group_relationships", params: params)
      Collection.from_response(response, type: Groups::Relationship, client: client)
    end

    def retrieve_relationship(uuid:)
      Groups::Relationship.new get_request("group_relationships/#{uuid}").dig("resource").merge(client: client)
    end
  end
end
