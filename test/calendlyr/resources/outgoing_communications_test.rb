# frozen_string_literal: true

require "test_helper"

class OutgoingCommunicationsResourceTest < Minitest::Test
  def test_list
    organization_uri = "https://api.calendly.com/organizations/abc123"
    stub(path: "outgoing_communications?organization=#{organization_uri}", response: { body: fixture_file("outgoing_communications/list"), status: 200 })

    communications = client.outgoing_communications.list(organization: organization_uri)

    assert_equal Calendlyr::Collection, communications.class
    assert_equal Calendlyr::OutgoingCommunication, communications.data.first.class
    assert_equal 1, communications.data.count
    assert_equal "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi", communications.next_page_token
    assert_equal "sms", communications.data.first.type
  end

  def test_list_with_bare_org_uuid
    bare_uuid = "abc123"
    expanded = "https://api.calendly.com/organizations/#{bare_uuid}"
    stub(path: "outgoing_communications?organization=#{expanded}", response: { body: fixture_file("outgoing_communications/list"), status: 200 })

    communications = client.outgoing_communications.list(organization: bare_uuid)

    assert_equal Calendlyr::Collection, communications.class
    assert_equal 1, communications.data.count
  end

  def test_list_all_returns_all_pages
    organization_uri = "https://api.calendly.com/organizations/abc123"
    token = "sNjq4TvMDfUHEl7zHRR0k0E1PCEJWvdi"
    stub(path: "outgoing_communications?organization=#{organization_uri}", response: { body: fixture_file("outgoing_communications/list"), status: 200 })
    stub(path: "outgoing_communications?organization=#{organization_uri}&page_token=#{token}", response: { body: fixture_file("outgoing_communications/list_page2"), status: 200 })

    communications = client.outgoing_communications.list_all(organization: organization_uri)

    assert_equal Array, communications.class
    assert_equal 2, communications.size
    assert_equal Calendlyr::OutgoingCommunication, communications.first.class
  end
end
