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
      handle_response request(url, Net::HTTP::Get, params: params)
    end

    def post_request(url, body:)
      handle_response request(url, Net::HTTP::Post, body: body)
    end

    def patch_request(url, body:)
      handle_response request(url, Net::HTTP::Patch, body: body)
    end

    def put_request(url, body:)
      handle_response request(url, Net::HTTP::Put, body: body)
    end

    def delete_request(url, params: {})
      handle_response request(url, Net::HTTP::Delete, params: params)
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

      attempts = 0

      loop do
        response = http.request(request)
        return response unless response.code == "429"
        return response if attempts >= MAX_RETRIES

        sleep retry_after_seconds(response, attempts)
        attempts += 1
      end
    end

    def handle_response(response)
      body_string = response.body.to_s

      body = begin
        body_string.empty? ? {} : JSON.parse(body_string)
      rescue JSON::ParserError
        {}
      end

      if ERROR_CODES.include? response.code
        raise ResponseErrorHandler.new(response.code, body).error
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
  end
end
