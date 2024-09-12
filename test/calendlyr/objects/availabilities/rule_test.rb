# frozen_string_literal: true

require "test_helper"

module Availabilities
  class RuleObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/availabilities/rule")).merge(client: client)
      @rule = Calendlyr::Availabilities::Rule.new(json)
    end

    def test_type
      assert_equal "wday", @rule.type
    end

    def test_intervals
      assert_equal 1, @rule.intervals.size
    end

    def test_wday
      assert_equal "sunday", @rule.wday
    end
  end
end
