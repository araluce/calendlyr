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

  def test_submissions
    response = {body: fixture_file("routing_forms/list_routing_form_submission"), status: 200}
    stub(path: "routing_form_submissions?form=#{@routing_form.uri}", response: response)

    submissions = @routing_form.submissions

    assert_equal 1, submissions.data.size
    assert_instance_of Calendlyr::RoutingForms::Submission, submissions.data.first
  end
end
