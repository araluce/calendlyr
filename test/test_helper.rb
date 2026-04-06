$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "simplecov"
SimpleCov.start
require "calendlyr"
require "minitest/autorun"
require "webmock/minitest"

class Minitest::Test
  def initialize(name)
    stub_user_me_request
    super
  end

  def client
    @client ||= Calendlyr::Client.new(token: "fake")
  end

  def fixture_file(fixture)
    File.read("test/fixtures/#{fixture}.json")
  end

  def stub(path:, method: :get, body: {}, response: {})
    stub_req = stub_request(method, "#{Calendlyr::Client::BASE_URL}/#{path}")
    stub_req.with(body: body) if %i[post put patch].include?(method)
    stub_req.to_return(**response)
    stub_req
  end

  private

  def stub_user_me_request
    stub(path: "users/me", response: {body: fixture_file("users/retrieve"), status: 200})
  end
end
