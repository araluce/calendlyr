require "net/http"
require "json"
require "openssl"
require "uri"

module Calendlyr
  class Resource
    attr_reader :client

    ERROR_CODES = %w[400 401 403 404 424 429 500]
    MAX_RETRIES = 3
    RETRY_BACKOFF = [1, 2, 4]

    def initialize(client)
      @client = client
    end

    private

    def get_request(url, params: {})
      handle_response request(url, Net::HTTP::Get, params: params), method: "GET", path: url
    end

    def post_request(url, body:)
      handle_response request(url, Net::HTTP::Post, body: body), method: "POST", path: url
    end

    def patch_request(url, body:)
      handle_response request(url, Net::HTTP::Patch, body: body), method: "PATCH", path: url
    end

    def put_request(url, body:)
      handle_response request(url, Net::HTTP::Put, body: body), method: "PUT", path: url
    end

    def delete_request(url, params: {})
      handle_response request(url, Net::HTTP::Delete, params: params), method: "DELETE", path: url
    end

    def request(url, req_type, body: {}, params: {}, base_url: Client::BASE_URL)
      uri = URI("#{base_url}/#{url}")

      if params.any?
        params = URI.decode_www_form(uri.query || "") + params.to_a
        uri.query = URI.encode_www_form params
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = client.open_timeout
      http.read_timeout = client.read_timeout

      request = req_type.new(uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{client.token}"
      request.body = body.to_json if body.any?

      logging_enabled = !logger.nil?
      start_time = monotonic_now if logging_enabled
      request_method = request.method
      request_url = uri.to_s if logging_enabled
      attempts = 0
      response = nil

      loop do
        response = http.request(request)
        break unless response.code == "429"
        break if attempts >= MAX_RETRIES

        backoff_seconds = retry_after_seconds(response, attempts)
        log(:warn, "retry_attempt=#{attempts + 1} method=#{request_method} url=#{request_url} status=429 backoff_seconds=#{backoff_seconds}")
        sleep backoff_seconds
        attempts += 1
      end

      if logging_enabled
        log(:info, "method=#{request_method} url=#{request_url} status=#{response.code} duration_ms=#{elapsed_milliseconds(start_time)}")
        log(:debug, "response_body=#{truncated_body(response.body.to_s)}")
      end

      response
    end

    def handle_response(response, method: nil, path: nil)
      body_string = response.body.to_s

      body = begin
        body_string.empty? ? {} : JSON.parse(body_string)
      rescue JSON::ParserError
        {}
      end

      if ERROR_CODES.include? response.code
        log(:error, "method=#{method} path=/#{path} status=#{response.code} response_body=#{truncated_body(body_string)}")
        raise ResponseErrorHandler.new(response.code, body, method: method, path: path).error
      end

      body
    end

    def retry_after_seconds(response, attempt)
      retry_after = response["Retry-After"]
      return retry_after.to_i if retry_after&.match?(/^\d+$/)

      RETRY_BACKOFF.fetch(attempt)
    end

    def expand_uri(value, resource_type)
      return value if value.nil? || value.start_with?("https://")

      "#{Client::BASE_URL}/#{resource_type}/#{value}"
    end

    def logger
      client.logger
    end

    def log(level, message)
      return unless logger

      logger.public_send(level, "[calendlyr] #{message}")
    end

    def truncated_body(body_string)
      return body_string if body_string.length <= 1000

      "#{body_string[0, 1000]}... (truncated)"
    end

    def monotonic_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def elapsed_milliseconds(start_time)
      ((monotonic_now - start_time) * 1000).round(1)
    end
  end
end
