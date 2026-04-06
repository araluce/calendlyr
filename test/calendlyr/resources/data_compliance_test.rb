# frozen_string_literal: true

require "test_helper"

class DataComplianceResourceTest < Minitest::Test
  def test_delete_invitee_data
    body = {emails: %w[test@test.com test2@test.com]}
    response = {body: fixture_file("data_compliance/delete_invitee_data"), status: 202}
    stub(method: :post, path: "data_compliance/deletion/invitees", body: body, response: response)

    assert client.data_compliance.delete_invitee_data(**body)
  end
end
