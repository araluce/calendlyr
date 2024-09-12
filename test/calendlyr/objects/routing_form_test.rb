# frozen_string_literal: true

require "test_helper"

class RoutingFormObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/routing_form")).merge(client: client)
    @routing_form = Calendlyr::RoutingForm.new(json)
  end

  def test_associated_organization
    organization = @routing_form.associated_organization

    assert_equal Calendlyr::Organization, organization.class
  end
end
