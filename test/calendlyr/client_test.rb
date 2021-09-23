require "test_helper"

class ClientTest < Minitest::Test
  def test_token
    client = Calendlyr::Client.new token: "test"
    assert_equal "test", client.token
  end
end
