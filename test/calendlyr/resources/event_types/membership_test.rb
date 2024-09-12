# frozen_string_literal: true

require "test_helper"

module EventTypes
  class MembershipTest < Minitest::Test
    def setup
      @event_type_uri = "https://api.calendly.com/event_types/abc123"
      response = {body: fixture_file("event_type_hosts/list"), status: 200}
      stub(path: "event_type_memberships?event_type=#{@event_type_uri}", response: response)
    end

    def test_list
      event_type_hosts = client.event_types.list_memberships(event_type: @event_type_uri)

      assert_equal Calendlyr::Collection, event_type_hosts.class
      assert_equal Calendlyr::EventTypes::Membership, event_type_hosts.data.first.class
      assert_equal 1, event_type_hosts.data.count
      assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", event_type_hosts.next_page_token
    end
  end
end
