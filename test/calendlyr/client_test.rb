require "test_helper"

class ClientTest < Minitest::Test
  def test_token
    assert_equal "fake", client.token
  end

  def test_inspect
    assert_equal "#<Calendlyr::Client>", client.inspect
  end

  def test_method_missing
    assert_raises NoMethodError do
      client.useers
    end
  end
end
