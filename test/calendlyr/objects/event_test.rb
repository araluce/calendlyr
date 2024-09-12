# frozen_string_literal: true

require "test_helper"

class EventObjectTest < Minitest::Test
  def setup
    json = JSON.parse(fixture_file("objects/event")).merge(client: client)
    @event = Calendlyr::Event.new(json)

    user_uuid = "GBGBDCAADAEDCRZ2"
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{user_uuid}", response: response)
  end

  def test_memberships
    memberships = @event.memberships

    assert_equal 1, memberships.count
    assert_equal "John Doe", memberships.first.name
    assert_equal Calendlyr::User, memberships.first.class
  end
end
