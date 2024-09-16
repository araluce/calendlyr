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
    assert_instance_of Calendlyr::User, memberships.first
  end

  def test_cancel
    response = {body: fixture_file("events/cancel_invitee"), status: 201}
    stub(method: :post, path: "scheduled_events/#{@event.uuid}/cancellation", response: response)

    cancellation = @event.cancel(reason: "I'm busy")

    assert_instance_of Calendlyr::Events::Cancellation, cancellation
    assert_equal "string", cancellation.reason
  end
end
