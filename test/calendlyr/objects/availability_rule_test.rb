# frozen_string_literal: true

require "test_helper"

class AvailabilityRuleObjectTest < Minitest::Test
  def test_associated_user
    json = JSON.parse(fixture_file("objects/availability_rule")).merge(client: client)
    availability_rule = Calendlyr::UserAvailabilitySchedule.new(json)

    assert_equal "wday", availability_rule.type
    assert_equal "sunday", availability_rule.wday
    assert_equal 1, availability_rule.intervals.count
  end
end
