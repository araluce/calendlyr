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

  def test_list_all_returns_all_pages
    bare_uuid = "ORG-123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    token = "d8T0LKQ1XsC2utmPlI7TFPpHX4SSfoGl"
    page1_response = {body: fixture_file("routing_forms/list"), status: 200}
    page2_response = {body: fixture_file("routing_forms/list_page2"), status: 200}
    stub(path: "routing_forms?organization=#{expanded}", response: page1_response)
    stub(path: "routing_forms?organization=#{expanded}&page_token=#{token}", response: page2_response)

    forms = client.routing_forms.list_all(organization: bare_uuid)

    assert_equal Array, forms.class
    assert_equal 2, forms.size
    assert_equal Calendlyr::RoutingForm, forms.first.class
  end

  def test_list_all_submissions_returns_all_pages
    bare_uuid = "FORM-123"
    expanded = "https://api.calendly.com/routing_forms/#{bare_uuid}"
    token = "d8T0LKQ1XsC2utmPlI7TFPpHX4SSfoGl"
    page1_response = {body: fixture_file("routing_forms/list_routing_form_submission"), status: 200}
    page2_response = {body: fixture_file("routing_forms/list_routing_form_submission_page2"), status: 200}
    stub(path: "routing_form_submissions?form=#{expanded}", response: page1_response)
    stub(path: "routing_form_submissions?form=#{expanded}&page_token=#{token}", response: page2_response)

    submissions = client.routing_forms.list_all_submissions(form: bare_uuid)

    assert_equal Array, submissions.class
    assert_equal 2, submissions.size
    assert_equal Calendlyr::RoutingForms::Submission, submissions.first.class
  end
end
