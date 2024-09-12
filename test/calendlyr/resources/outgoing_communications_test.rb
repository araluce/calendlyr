# frozen_string_literal: true

require "test_helper"

class OutgoingCommunicationsResourceTest < Minitest::Test
  def test_list
    response = {body: fixture_file("outgoing_communications/list"), status: 200}
    stub(path: "outgoing_communications", response: response)
    outgoing_communications = client.outgoing_communications.list

    assert_equal Calendlyr::Collection, outgoing_communications.class
    assert_equal Calendlyr::Object, outgoing_communications.data.first.class
    assert_equal 1, outgoing_communications.data.count
    assert_equal "sms", outgoing_communications.data.first.type
  end
end
