# frozen_string_literal: true

require "test_helper"

module Webhooks
  class SubscriptionObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/webhooks/subscription")).merge(client: client)
      @subscription = Calendlyr::Webhooks::Subscription.new(json)

      user_uuid = "AAAAAAAAAAAAAAAA"
      response = {body: fixture_file("users/retrieve"), status: 200}
      stub(path: "users/#{user_uuid}", response: response)
    end

    def test_associated_organization
      organization = @subscription.associated_organization

      assert_equal Calendlyr::Organization, organization.class
    end

    def test_associated_user
      user = @subscription.associated_user

      assert_equal Calendlyr::User, user.class
    end

    def test_associated_creator
      creator = @subscription.associated_creator

      assert_equal Calendlyr::User, creator.class
    end

    def test_active?
      assert @subscription.active?
    end

    def test_disabled?
      refute @subscription.disabled?
    end
  end
end

