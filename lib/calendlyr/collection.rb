module Calendlyr
  class Collection
    attr_reader :data, :count, :next_page, :next_page_token, :client

    def self.from_response(response, key:, type:, client:)
      new(
        data: response[key].map { |attrs| type.new(attrs.merge(client: client)) },
        count: response.dig("pagination", "count"),
        next_page: response.dig("pagination", "next_page"),
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

      uri = URI.parse(url)
      CGI.parse(uri.query)
    end
  end
end
