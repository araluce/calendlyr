require "net/http"
require "json"
require "openssl"
require "uri"

module Calendlyr
  class Resource
    attr_reader :client

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
      body = JSON.parse(response.read_body)
      case response.code
      when 400
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 401
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 403
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 404
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 429
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 500
        raise Error, "#{body["title"]}. #{body["message"]}"
      when 503
        raise Error, "#{body["title"]}. #{body["message"]}"
      else
        body
      end
    end
  end
end
