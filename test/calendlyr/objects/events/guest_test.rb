# frozen_string_literal: true

require "test_helper"

module Events
  class GuestObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/events/guest")).merge(client: client)
      @guest = Calendlyr::Events::Guest.new(json)
    end

    def test_email
      assert_equal "user@example.com", @guest.email
    end
  end
end
