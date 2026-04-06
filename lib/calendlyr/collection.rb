require "uri"
require "cgi"

module Calendlyr
  class Collection
    include Enumerable

    attr_reader :data, :next_page, :next_page_token, :client

    def self.from_response(response, type:, client:)
      new(
        data: response["collection"].map { |attrs| type.new(attrs.merge(client: client)) },
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

    def each(&)
      data.each(&)
    end

    def count(*args, &block)
      if block || args.any?
        super
      else
        @count
      end
    end

    private

    def get_params(url)
      return {} unless url

      uri = URI.parse(url)
      CGI.parse(uri.query)
    end
  end
end
