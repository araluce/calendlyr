# frozen_string_literal: true

require "test_helper"

module RoutingForms
  class SubmissionObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/routing_forms/submission")).merge(client: client)
      @submission = Calendlyr::RoutingForms::Submission.new(json)
    end

    def test_associated_routing_form
      uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("routing_forms/retrieve"), status: 200}
      stub(path: "routing_forms/#{uuid}", response: response)

      routing_form = @submission.associated_routing_form

      assert_equal Calendlyr::RoutingForm, routing_form.class
    end
  end
end

