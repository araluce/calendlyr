module Calendlyr
  class ActivityLog < Object
    def associated_organization
      @associated_organization ||= Organization.new({"uri" => organization}.merge(client: client))
    end
  end
end
