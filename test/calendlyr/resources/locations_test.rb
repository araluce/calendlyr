# frozen_string_literal: true

require "test_helper"

class LocationsResourceTest < Minitest::Test
  def setup
    list_response = {body: fixture_file("locations/list"), status: 200}
    stub(path: "locations", response: list_response)
  end

  def test_list
    locations = client.locations.list

    assert_equal Calendlyr::Collection, locations.class
    assert_equal Calendlyr::Location, locations.data.first.class
    assert_equal 1, locations.data.count
  end
end
