# frozen_string_literal: true

require "test_helper"

class RoutingFormsResourceTest < Minitest::Test
  def test_list_with_bare_org_uuid
    bare_uuid = "ORG-123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    stub(path: "routing_forms?organization=#{expanded}", response: {body: fixture_file("routing_forms/list"), status: 200})

    forms = client.routing_forms.list(organization: bare_uuid)

    assert_equal Calendlyr::Collection, forms.class
  end

  def test_list_submissions_with_bare_form_uuid
    bare_uuid = "FORM-123"
    expanded = "https://api.calendly.com/routing_forms/#{bare_uuid}"
    stub(path: "routing_form_submissions?form=#{expanded}", response: {body: fixture_file("routing_forms/list_routing_form_submission"), status: 200})

    submissions = client.routing_forms.list_submissions(form: bare_uuid)

    assert_equal Calendlyr::Collection, submissions.class
  end
end
