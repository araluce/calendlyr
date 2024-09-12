# frozen_string_literal: true

require "test_helper"

module Events
  class GuestObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/events/guest")).merge(client: client)
      @guest = Calendlyr::Events::Guest.new(json)
    end

    def test_email
      assert "user@example.com", @guest.email
    end
  end
end
