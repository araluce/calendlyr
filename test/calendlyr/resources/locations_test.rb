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

  def test_list_all_returns_all_pages
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    page2_response = {body: fixture_file("locations/list_page2"), status: 200}
    stub(path: "locations?page_token=#{token}", response: page2_response)

    locations = client.locations.list_all

    assert_equal Array, locations.class
    assert_equal 2, locations.size
    assert_equal Calendlyr::Location, locations.first.class
  end
end
