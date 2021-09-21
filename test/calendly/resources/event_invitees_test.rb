# frozen_string_literal: true

require "test_helper"

class EventInviteesResourceTest < Minitest::Test
  def test_list
    event_uuid = "ABCDABCDABCDABCD"
    stub = stub_request("scheduled_events/#{event_uuid}/invitees", response: stub_response(fixture: "event_invitees/list"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    event_invitees = client.event_invitees.list(event_uuid: event_uuid)

    assert_equal Calendly::Collection, event_invitees.class
    assert_equal Calendly::EventInvitee, event_invitees.data.first.class
    assert_equal 1, event_invitees.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_invitees.next_page_token
  end

  def test_retrieve
    event_uuid = "AAAAAAAAAAAAAAAA"
    invitee_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("scheduled_events/#{event_uuid}/invitees/#{invitee_uuid}", response: stub_response(fixture: "event_invitees/retrieve"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    event_invitee = client.event_invitees.retrieve(event_uuid: event_uuid, invitee_uuid: invitee_uuid)

    assert_equal Calendly::EventInvitee, event_invitee.class
    assert_equal "https://api.calendly.com/api/v2/scheduled_events/ABCDABCDABCDABCD/invitees/ABCDABCDABCDABCD", event_invitee.uri
    assert_equal "John Doe", event_invitee.name
  end
end
