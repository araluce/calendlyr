module Calendly
  class Collection
    attr_reader :data, :total, :next_page, :next_page_token, :client

    def self.from_response(response, key:, type:, client:)
      body = response.body
      new(
        data: body[key].map { |attrs| type.new(attrs, client: client) },
        count: body.dig("pagination", "count"),
        next_page: body.dig("pagination", "next_page"),
        client: client
      )
    end

    def initialize(data:, count:, next_page:, client:)
      @data = data
      @count = count
      @next_page = next_page
      @next_page_token = get_params(next_page)["page_token"]&.first
      @client = client
    end

    private

    def get_params(url)
      return {} unless url

      uri = URI::parse(url)
      CGI::parse(uri.query)
    end
  end
end
