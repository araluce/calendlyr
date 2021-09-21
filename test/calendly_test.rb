require "test_helper"

class CalendlyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Calendly::VERSION
  end
end
