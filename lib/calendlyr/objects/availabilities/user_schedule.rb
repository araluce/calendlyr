module Calendlyr
  class Availabilities::UserSchedule < Object
    def associated_user
      client.users.retrieve(uuid: get_slug(user))
    end

    def availability_rules
      rules.map do |rule|
        Availabilities::Rule.new(rule.to_h.merge(client: client))
      end
    end
  end
end
