$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "calendly"
require "minitest/autorun"
require "webmock/minitest"

class Minitest::Test
  def client
    Calendly::Client.new(api_key: "fake")
  end

  def fixture_file(fixture)
    File.read("test/fixtures/#{fixture}.json")
  end

  def stub(path:, method: :get, body: {}, response: {})
    stub_req = stub_request(method, "#{Calendly::Client::BASE_URL}/#{path}")
    stub_req.with(body: body) if [:post, :put, :patch].include?(method)
    stub_req.to_return(**response)
  end
end
