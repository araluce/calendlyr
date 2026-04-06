# frozen_string_literal: true

require "test_helper"

module Webhooks
  class PayloadObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/webhooks/payload")).merge(client: client)
      @payload = Calendlyr::Webhooks::Payload.new(json)
    end

    def test_event
      assert_equal "invitee.created", @payload.event
    end

    def test_payload_is_invitee_payload_for_known_invitee_events
      assert_instance_of Calendlyr::Webhooks::InviteePayload, @payload.payload
    end

    def test_payload_stays_generic_object_for_unknown_events
      json = JSON.parse(fixture_file("objects/webhooks/payload")).merge(
        "event" => "routing_form_submission.created",
        "client" => client
      )
      payload = Calendlyr::Webhooks::Payload.new(json)

      assert_instance_of Calendlyr::Object, payload.payload
      refute_instance_of Calendlyr::Webhooks::InviteePayload, payload.payload
    end
  end
end
