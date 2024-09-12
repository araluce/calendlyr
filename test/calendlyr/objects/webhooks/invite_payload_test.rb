# frozen_string_literal: true

require "test_helper"

module Webhooks
  class InviteePayloadObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/webhooks/invite_payload")).merge(client: client)
      @invite_payload = Calendlyr::Webhooks::InviteePayload.new(json)

      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/AAAAAAAAAAAAAAAA", response: response)
    end

    def test_associated_event
      response = {body: fixture_file("events/retrieve"), status: 200}
      stub(path: "scheduled_events/AAAAAAAAAAAAAAAA", response: response)

      event = @invite_payload.associated_event

      assert_equal Calendlyr::Event, event.class
    end

    def test_associated_routing_form_submission
      response = {body: fixture_file("routing_forms/retrieve_routing_form_submission"), status: 200}
      stub(path: "routing_form_submissions/AAAAAAAAAAAAAAAA", response: response)

      routing_form = @invite_payload.associated_routing_form_submission

      assert_equal Calendlyr::RoutingForms::Submission, routing_form.class
    end

    def test_associated_invitee_no_show
      response = {body: fixture_file("events/retrieve_invitee_no_show"), status: 200}
      stub(path: "invitee_no_shows/6ee96ed4-83a3-4966-a278-cd19b3c02e09", response: response)

      invitee_no_show = @invite_payload.associated_invitee_no_show

      assert_equal Calendlyr::Events::InviteeNoShow, invitee_no_show.class
    end
  end
end
