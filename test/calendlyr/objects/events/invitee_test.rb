# frozen_string_literal: true

require "test_helper"

module Events
  class InviteeObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/events/invitee")).merge(client: client)
      @invitee = Calendlyr::Events::Invitee.new(json)
    end

    def test_email
      assert "user@example.com", @invitee.email
    end

    def test_cancel
      response = {body: fixture_file("events/cancel_invitee"), status: 201}
      stub(method: :post, path: "scheduled_events/#{@invitee.uuid}/cancellation", response: response)

      cancellation = @invitee.cancel(reason: "I'm busy")

      assert_instance_of Calendlyr::Events::Cancellation, cancellation
      assert_equal "host", cancellation.canceler_type
    end

    def test_create_no_shows
      response = {body: fixture_file("events/create_invitee_no_show"), status: 201}
      stub(method: :post, path: "invitee_no_shows", body: {invitee: @invitee.uri}, response: response)

      no_show = @invitee.create_no_shows

      assert_instance_of Calendlyr::Events::InviteeNoShow, no_show
    end
  end
end
