# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_retrieve
    user_uuid = "AAAAAAAAAAAAAAAA"
    stub = stub_request("users/#{user_uuid}", response: stub_response(fixture: "users/retrieve"))
    client = Calendly::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    user = client.users.retrieve(user_uuid: user_uuid)

    assert_equal Calendly::User, user.class
    assert_equal "https://api.calendly.com/users/AAAAAAAAAAAAAAAA", user.uri
    assert_equal "John Doe", user.name
    assert_equal "acmesales", user.slug
    assert_equal "test@example.com", user.email
  end
end
