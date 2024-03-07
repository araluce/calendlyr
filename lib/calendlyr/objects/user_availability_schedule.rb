module Calendlyr
  class UserAvailabilitySchedule < Object
    def associated_user
      client.users.retrieve user_uuid: get_slug(user)
    end

    def availability_rules
      rules.map do |rule|
        AvailabilityRule.new(rule.to_h)
      end
    end
  end
end
