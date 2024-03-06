require "net/http"
require "json"
require "openssl"
require "uri"

module Calendlyr
  class Resource
    attr_reader :client

    ERROR_CODES = %w[400 401 403 404 424 500]

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
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = req_type.new(uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{client.token}"
      request.body = body.to_json if body.any?

      http.request(request)
    end

    def handle_response(response)
      return true unless response.read_body

      body = JSON.parse(response.read_body)
      if ERROR_CODES.include? response.code
        raise ResponseErrorHandler.new(response.code, body).error
      else
        body
      end
    end
  end
end
