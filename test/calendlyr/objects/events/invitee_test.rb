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
  end
end
