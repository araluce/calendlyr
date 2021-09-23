$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"
SimpleCov.start
if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
require "calendlyr"
require "minitest/autorun"
require "webmock/minitest"

class Minitest::Test
  def client
    Calendlyr::Client.new(token: "fake")
  end

  def fixture_file(fixture)
    File.read("test/fixtures/#{fixture}.json")
  end

  def stub(path:, method: :get, body: {}, response: {})
    stub_req = stub_request(method, "#{Calendlyr::Client::BASE_URL}/#{path}")
    stub_req.with(body: body) if [:post, :put, :patch].include?(method)
    stub_req.to_return(**response)
  end
end
