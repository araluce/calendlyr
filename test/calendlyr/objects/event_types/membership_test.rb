# frozen_string_literal: true

require "test_helper"

module EventTypes
  class MembershipObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/event_types/membership")).merge(client: client)
      @membership = Calendlyr::EventTypes::Membership.new(json)

      event_type_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("event_types/retrieve"), status: 200}
      stub(path: "event_types/#{event_type_uuid}", response: response)

      user_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/#{user_uuid}", response: response)
    end

    def test_associated_event_type
      event_type = @membership.associated_event_type

      assert_equal "15 Minute Meeting", event_type.name
    end

    def test_associated_member
      member = @membership.associated_member

      assert_equal "John Doe", member.name
    end
  end
end
