# frozen_string_literal: true

require "test_helper"

module EventTypes
  class ProfileObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/event_types/profile")).merge(client: client)
      @profile = Calendlyr::EventTypes::Profile.new(json)

      owner_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/#{owner_uuid}", response: response)
    end

    def test_associated_owner
      owner = @profile.associated_owner

      assert_equal "John Doe", owner.name
      assert_equal Calendlyr::User, owner.class
    end
  end
end
