# frozen_string_literal: true

require "test_helper"

class ResourceTest < Minitest::Test
  class HttpSpy
    attr_reader :host, :port, :last_request, :request_count
    attr_accessor :use_ssl, :open_timeout, :read_timeout

    def initialize(responses:, host:, port:)
      @responses = responses
      @host = host
      @port = port
      @request_count = 0
    end

    def request(request)
      @last_request = request
      @request_count += 1
      @responses.fetch(@request_count - 1)
    end
  end

  class ResponseStub
    attr_reader :body, :code

    def initialize(body:, code:, headers: {})
      @body = body
      @code = code
      @headers = headers
    end

    def [](header)
      @headers[header]
    end
  end

  def test_handle_response_error
    Calendlyr::ERROR_TYPES.each do |error_code, error_class|
      stub(path: "users/me", response: {body: fixture_file("resources/#{error_code}"), status: error_code.to_i})

      assert_raises Calendlyr.const_get(error_class) do
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

  def test_error_exposes_structured_attributes
    error = Calendlyr::NotFound.new(
      "not found",
      status: "404",
      http_method: "GET",
      path: "users/INVALID",
      response_body: {"title" => "Not Found"}
    )

    assert_equal "404", error.status
    assert_equal "GET", error.http_method
    assert_equal "users/INVALID", error.path
    assert_equal({"title" => "Not Found"}, error.response_body)
  end

  def test_error_plain_message_keeps_backward_compatibility
    error = Calendlyr::Error.new("plain message")

    assert_equal "plain message", error.message
    assert_nil error.status
    assert_nil error.http_method
    assert_nil error.path
    assert_nil error.response_body
  end

  def test_error_no_arg_construction_preserves_standard_error_message
    error = Calendlyr::Error.new

    assert_equal "Calendlyr::Error", error.message
    assert_nil error.status
    assert_nil error.http_method
    assert_nil error.path
    assert_nil error.response_body
  end

  def test_dynamic_error_subclass_retains_structured_attributes
    error = Calendlyr::Unauthenticated.new("msg", status: "401", http_method: "GET")

    assert_equal "401", error.status
    assert_equal "GET", error.http_method
    assert_instance_of Calendlyr::Unauthenticated, error
    assert_kind_of Calendlyr::Error, error
  end

  def test_response_error_handler_builds_contextual_message_and_body
    body = {"title" => "Not Found", "message" => "Resource does not exist"}
    error = Calendlyr::ResponseErrorHandler.new("404", body, method: "GET", path: "users/INVALID").error

    assert_equal "[Error 404] GET /users/INVALID — Not Found. Resource does not exist", error.message
    assert_equal body, error.response_body
    assert_equal "404", error.status
    assert_equal "GET", error.http_method
    assert_equal "users/INVALID", error.path
  end

  def test_response_error_handler_omits_missing_title_and_message_without_error
    error_without_title = Calendlyr::ResponseErrorHandler.new("404", {"message" => "Only message"}, method: "GET", path: "users/missing").error
    error_without_message = Calendlyr::ResponseErrorHandler.new("404", {"title" => "Only title"}, method: "GET", path: "users/missing").error
    error_without_both = Calendlyr::ResponseErrorHandler.new("404", {}, method: "GET", path: "users/missing").error

    assert_equal "[Error 404] GET /users/missing — Only message", error_without_title.message
    assert_equal "[Error 404] GET /users/missing — Only title", error_without_message.message
    assert_equal "[Error 404] GET /users/missing", error_without_both.message
  end

  def test_response_error_handler_preserves_legacy_message_without_context
    body = {"title" => "Not Found", "message" => "Resource does not exist"}
    error = Calendlyr::ResponseErrorHandler.new("404", body).error

    assert_equal "[Error 404] Not Found. Resource does not exist", error.message
    assert_nil error.http_method
    assert_nil error.path
  end

  def test_response_error_handler_429_uses_contextual_fixed_message
    error = Calendlyr::ResponseErrorHandler.new("429", {}, method: "POST", path: "scheduled_events").error

    assert_equal "[Error 429] POST /scheduled_events — Too many requests, please try again later.", error.message
    assert_equal "429", error.status
    assert_equal "POST", error.http_method
    assert_equal "scheduled_events", error.path
  end

  def test_handle_response_invalid_json_returns_empty_hash
    resource = Calendlyr::Resource.new(client)
    response = ResponseStub.new(body: "not json", code: "200")

    assert_equal({}, resource.send(:handle_response, response))
  end

  def test_handle_response_non_json_errors_propagate
    resource = Calendlyr::Resource.new(client)
    response = ResponseStub.new(body: '{"key":"value"}', code: "200")

    JSON.stub(:parse, proc { raise StandardError, "boom" }) do
      assert_raises StandardError do
        resource.send(:handle_response, response)
      end
    end
  end

  def test_request_uses_default_client_timeouts
    resource = Calendlyr::Resource.new(client)
    response = ResponseStub.new(body: "{}", code: "200")
    http_spy = HttpSpy.new(responses: [response], host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      resource.send(:request, "users/me", Net::HTTP::Get)
    end

    assert_equal 30, http_spy.open_timeout
    assert_equal 30, http_spy.read_timeout
  end

  def test_request_uses_custom_client_timeouts
    custom_client = Calendlyr::Client.new(token: "fake", open_timeout: 10, read_timeout: 12)
    resource = Calendlyr::Resource.new(custom_client)
    response = ResponseStub.new(body: "{}", code: "200")
    http_spy = HttpSpy.new(responses: [response], host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      resource.send(:request, "users/me", Net::HTTP::Get)
    end

    assert_equal 10, http_spy.open_timeout
    assert_equal 12, http_spy.read_timeout
  end

  def test_request_retries_after_429_and_returns_success_response
    resource = Calendlyr::Resource.new(client)
    responses = [
      ResponseStub.new(body: fixture_file("resources/429"), code: "429"),
      ResponseStub.new(body: '{"ok":true}', code: "200")
    ]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)
    sleeps = []

    Net::HTTP.stub(:new, http_spy) do
      resource.stub(:sleep, proc { |seconds| sleeps << seconds }) do
        result = resource.send(:get_request, "users/me")

        assert_equal({"ok" => true}, result)
      end
    end

    assert_equal 2, http_spy.request_count
    assert_equal [1], sleeps
  end

  def test_request_uses_retry_after_header_on_429
    resource = Calendlyr::Resource.new(client)
    responses = [
      ResponseStub.new(body: fixture_file("resources/429"), code: "429", headers: {"Retry-After" => "5"}),
      ResponseStub.new(body: '{"ok":true}', code: "200")
    ]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)
    sleeps = []

    Net::HTTP.stub(:new, http_spy) do
      resource.stub(:sleep, proc { |seconds| sleeps << seconds }) do
        resource.send(:get_request, "users/me")
      end
    end

    assert_equal [5], sleeps
  end

  def test_request_raises_too_many_requests_after_exhausting_retries
    resource = Calendlyr::Resource.new(client)
    responses = [
      ResponseStub.new(body: fixture_file("resources/429"), code: "429"),
      ResponseStub.new(body: fixture_file("resources/429"), code: "429"),
      ResponseStub.new(body: fixture_file("resources/429"), code: "429"),
      ResponseStub.new(body: fixture_file("resources/429"), code: "429")
    ]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)
    sleeps = []

    Net::HTTP.stub(:new, http_spy) do
      resource.stub(:sleep, proc { |seconds| sleeps << seconds }) do
        error = assert_raises Calendlyr::TooManyRequests do
          resource.send(:get_request, "users/me")
        end

        assert_equal "429", error.status
        assert_equal "GET", error.http_method
        assert_equal "users/me", error.path
        assert_equal "[Error 429] GET /users/me — Too many requests, please try again later.", error.message
      end
    end

    assert_equal [1, 2, 4], sleeps
    assert_equal 4, http_spy.request_count
  end

  def test_request_does_not_retry_non_429_errors
    resource = Calendlyr::Resource.new(client)
    responses = [ResponseStub.new(body: fixture_file("resources/401"), code: "401")]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      resource.stub(:sleep, proc { raise "sleep should not be called" }) do
        assert_raises Calendlyr::Unauthenticated do
          resource.send(:get_request, "users/me")
        end
      end
    end

    assert_equal 1, http_spy.request_count
  end

  def test_get_request_error_propagates_http_method_and_path
    resource = Calendlyr::Resource.new(client)
    responses = [ResponseStub.new(body: fixture_file("resources/404"), code: "404")]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      error = assert_raises Calendlyr::NotFound do
        resource.send(:get_request, "users/me")
      end

      assert_equal "GET", error.http_method
      assert_equal "users/me", error.path
    end
  end

  def test_post_request_error_propagates_http_method_and_path
    resource = Calendlyr::Resource.new(client)
    responses = [ResponseStub.new(body: fixture_file("resources/400"), code: "400")]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      error = assert_raises Calendlyr::BadRequest do
        resource.send(:post_request, "scheduled_events", body: {})
      end

      assert_equal "POST", error.http_method
      assert_equal "scheduled_events", error.path
    end
  end

  def test_delete_request_error_propagates_http_method_and_path
    resource = Calendlyr::Resource.new(client)
    responses = [ResponseStub.new(body: fixture_file("resources/403"), code: "403")]
    http_spy = HttpSpy.new(responses: responses, host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      error = assert_raises Calendlyr::PermissionDenied do
        resource.send(:delete_request, "event_types/UUID")
      end

      assert_equal "DELETE", error.http_method
      assert_equal "event_types/UUID", error.path
    end
  end

  def test_put_request_sends_json_body_and_handles_response
    resource = Calendlyr::Resource.new(client)
    response = ResponseStub.new(body: '{"updated":true}', code: "200")
    http_spy = HttpSpy.new(responses: [response], host: "api.calendly.com", port: 443)

    Net::HTTP.stub(:new, http_spy) do
      result = resource.send(:put_request, "users/me", body: {key: "val"})

      assert_equal({"updated" => true}, result)
      assert_equal "{\"key\":\"val\"}", http_spy.last_request.body
    end
  end

  def test_expand_uri_nil_passthrough
    resource = Calendlyr::Resource.new(client)
    assert_nil resource.send(:expand_uri, nil, "users")
  end

  def test_expand_uri_full_uri_passthrough
    resource = Calendlyr::Resource.new(client)
    uri = "https://api.calendly.com/users/ABC123"
    assert_equal uri, resource.send(:expand_uri, uri, "users")
  end

  def test_expand_uri_bare_uuid_expansion
    resource = Calendlyr::Resource.new(client)
    assert_equal "https://api.calendly.com/users/ABC123",
      resource.send(:expand_uri, "ABC123", "users")
  end
end
