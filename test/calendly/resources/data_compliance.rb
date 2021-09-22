# frozen_string_literal: true

require "test_helper"

class DataComplianceResourceTest < Minitest::Test
  def test_delete_invitee_data
    body = {emails: %w[test@test.com test2@test.com]}
    stub = stub_request("data_compliance/deletion/invitees", method: :post, body: body, response: stub_response(fixture: "data_compliance/delete_invitee_data", status: 202))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    assert client.data_compliance.delete_invitee_data(**body)
  end
end
