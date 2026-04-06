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
        assert_raises Calendlyr::TooManyRequests do
          resource.send(:get_request, "users/me")
        end
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
