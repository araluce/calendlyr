require "test_helper"

class CollectionTest < Minitest::Test
  def build_collection
    data = [
      Calendlyr::Object.new(name: "Alice"),
      Calendlyr::Object.new(name: "Bob")
    ]

    Calendlyr::Collection.new(data: data, count: 2, next_page: nil, client: client)
  end

  def test_each_yields_items
    collection = build_collection
    names = []

    collection.each do |item|
      names << item.name
    end

    assert_equal %w[Alice Bob], names
  end

  def test_map_is_available_from_enumerable
    collection = build_collection

    assert_equal %w[Alice Bob], collection.map(&:name)
  end

  def test_collection_responds_to_select
    collection = build_collection

    assert collection.respond_to?(:select)
  end

  def test_count_without_block_returns_metadata_count
    collection = Calendlyr::Collection.new(
      data: [Calendlyr::Object.new(name: "Alice")],
      count: 10,
      next_page: nil,
      client: client
    )

    assert_equal 10, collection.count
  end

  def test_count_with_block_uses_enumerable_count
    collection = build_collection

    assert_equal(1, collection.count { |item| item.name == "Alice" })
  end

  def test_count_with_argument_uses_enumerable_count
    alice = Calendlyr::Object.new(name: "Alice")
    collection = Calendlyr::Collection.new(
      data: [alice, Calendlyr::Object.new(name: "Bob")],
      count: 10,
      next_page: nil,
      client: client
    )

    assert_equal 1, collection.count(alice)
  end
end
