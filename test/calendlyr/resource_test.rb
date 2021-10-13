# frozen_string_literal: true

require "test_helper"

class ResourceTest < Minitest::Test
  def test_handle_response_error
    error_code = Calendlyr::Resource::ERROR_CODES.sample
    stub(path: "users/me", response: {body: fixture_file("resources/#{error_code}"), status: error_code.to_i})

    assert_raises Calendlyr::Error do
      client.me
    end
  end
end
