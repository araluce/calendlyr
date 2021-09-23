# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_retrieve
    user_uuid = "AAAAAAAAAAAAAAAA"
    response = {body: fixture_file("users/retrieve"), status: 200}
    stub(path: "users/#{user_uuid}", response: response)
    user = client.users.retrieve(user_uuid: user_uuid)

    assert_equal Calendly::User, user.class
    assert_equal "https://api.calendly.com/users/AAAAAAAAAAAAAAAA", user.uri
    assert_equal "John Doe", user.name
    assert_equal "acmesales", user.slug
    assert_equal "test@example.com", user.email
  end
end
