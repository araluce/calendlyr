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

  def test_respond_to_missing?
    assert client.respond_to?(:users)
    refute client.respond_to?(:useers)
  end
end
