require "uri"

module Calendlyr
  class Collection
    include Enumerable

    attr_reader :data, :next_page_url, :next_page_token, :client

    def self.from_response(response, type:, client:, next_page_caller: nil)
      new(
        data: response["collection"].map { |attrs| type.new(attrs.merge(client: client)) },
        count: response.dig("pagination", "count"),
        next_page_url: response.dig("pagination", "next_page"),
        client: client,
        next_page_caller: next_page_caller
      )
    end

    def initialize(data:, count:, next_page_url:, client:, next_page_caller: nil)
      @data = data
      @count = count
      @next_page_url = next_page_url
      @next_page_token = get_params(next_page_url)["page_token"]&.first
      @client = client
      @next_page_caller = next_page_caller
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

    def next_page
      return nil if @next_page_token.nil? || @next_page_caller.nil?

      @next_page_caller.call(page_token: @next_page_token)
    end

    def auto_paginate
      Enumerator.new do |yielder|
        current = self
        while current
          current.data.each { |item| yielder << item }
          current = current.next_page
        end
      end.lazy
    end

    private

    def get_params(url)
      return {} unless url

      uri = URI.parse(url)
      return {} unless uri.query

      URI.decode_www_form(uri.query).to_h { |k, v| [k, [v]] }
    end
  end
end
