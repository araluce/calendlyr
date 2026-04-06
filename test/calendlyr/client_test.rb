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

  def test_default_timeouts
    new_client = Calendlyr::Client.new(token: "fake")

    assert_equal 30, new_client.open_timeout
    assert_equal 30, new_client.read_timeout
  end

  def test_custom_timeouts
    new_client = Calendlyr::Client.new(token: "fake", open_timeout: 10, read_timeout: 15)

    assert_equal 10, new_client.open_timeout
    assert_equal 15, new_client.read_timeout
  end
end
