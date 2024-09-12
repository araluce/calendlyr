# frozen_string_literal: true

require "test_helper"

class ActivityLogObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/activity_log")).merge(client: client)
    @activity_log = Calendlyr::ActivityLog.new(json)

    user_uuid = "SDLKJENFJKD123"
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{user_uuid}", response: response)
  end

  def test_associated_organization
    organization = @activity_log.associated_organization

    assert_equal Calendlyr::Organization, organization.class
  end

  def test_associated_actor
    user = @activity_log.associated_actor

    assert_equal "John Doe", user.name
  end
end
