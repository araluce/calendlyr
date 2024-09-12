# frozen_string_literal: true

require "test_helper"

module Events
  class InviteeNoShowObjectTest < Minitest::Test
    def setup
      json = JSON.parse(fixture_file("objects/events/invitee_no_show")).merge(client: client)
      @invitee_no_show = Calendlyr::Events::InviteeNoShow.new(json)
    end

    def test_created_at
      assert "2019-01-02T03:04:05.678123Z", @invitee_no_show.created_at
    end

    def test_delete
      response = {body: fixture_file("events/delete_invitee_no_show"), status: 204}
      stub(method: :delete, path: "invitee_no_shows/#{@invitee_no_show.uuid}", response: response)

      assert @invitee_no_show.delete
    end
  end
end
