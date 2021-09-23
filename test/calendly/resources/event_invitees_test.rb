# frozen_string_literal: true

require "test_helper"

class EventInviteesResourceTest < Minitest::Test
  def test_list
    event_uuid = "ABCDABCDABCDABCD"
    response = {body: fixture_file("event_invitees/list"), status: 200}
    stub(path: "scheduled_events/#{event_uuid}/invitees", response: response)
    event_invitees = client.event_invitees.list(event_uuid: event_uuid)

    assert_equal Calendly::Collection, event_invitees.class
    assert_equal Calendly::EventInvitee, event_invitees.data.first.class
    assert_equal 1, event_invitees.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_invitees.next_page_token
  end

  def test_retrieve
    event_uuid = "AAAAAAAAAAAAAAAA"
    invitee_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("event_invitees/retrieve"), status: 200}
    stub(path: "scheduled_events/#{event_uuid}/invitees/#{invitee_uuid}", response: response)
    event_invitee = client.event_invitees.retrieve(event_uuid: event_uuid, invitee_uuid: invitee_uuid)

    assert_equal Calendly::EventInvitee, event_invitee.class
    assert_equal "https://api.calendly.com/api/v2/scheduled_events/ABCDABCDABCDABCD/invitees/ABCDABCDABCDABCD", event_invitee.uri
    assert_equal "John Doe", event_invitee.name
  end
end
