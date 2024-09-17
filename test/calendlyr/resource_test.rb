# frozen_string_literal: true

require "test_helper"

class ResourceTest < Minitest::Test
  def test_handle_response_error
    Calendlyr::ResponseErrorHandler::ERROR_TYPES.each do |error_code, error_class|
      stub(path: "users/me", response: {body: fixture_file("resources/#{error_code}"), status: error_code.to_i})

      assert_raises "Calendlyr::#{error_class}" do
        client.me
      end
    end
  end

  def test_handle_response_error_payment
    stub(path: "users/me", response: {body: fixture_file("resources/403_payment_required"), status: 403})

    assert_raises Calendlyr::PaymentRequired do
      client.me
    end
  end

  def test_handle_response_too_many_requests
    stub(path: "users/me", response: {body: "", status: 429})

    assert_raises Calendlyr::TooManyRequests do
      client.me
    end
  end
end
