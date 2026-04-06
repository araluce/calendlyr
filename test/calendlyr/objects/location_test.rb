# frozen_string_literal: true

require "test_helper"

class LocationObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/location")).merge(client: client)
    @location = Calendlyr::Location.new(json)
  end

  def test_uri
    assert_equal "https://api.calendly.com/locations/AAAAAAAAAAAAAAAA", @location.uri
  end

  def test_type
    assert_equal "zoom", @location.type
  end

  def test_display_name
    assert_equal "Zoom", @location.display_name
  end
end
