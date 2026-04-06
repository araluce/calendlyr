# frozen_string_literal: true

require "test_helper"

class ShareObjectTest < Minitest::Test
  def test_share
    json = JSON.parse(fixture_file("objects/share")).merge(client: client)
    @share = Calendlyr::Share.new(json)

    assert_instance_of Calendlyr::Share, @share
    assert_equal 1, @share.scheduling_links.size
  end
end
