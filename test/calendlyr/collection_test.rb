require "test_helper"

class CollectionTest < Minitest::Test
  def build_collection
    data = [
      Calendlyr::Object.new(name: "Alice"),
      Calendlyr::Object.new(name: "Bob")
    ]

    Calendlyr::Collection.new(data: data, count: 2, next_page_url: nil, client: client)
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
      next_page_url: nil,
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
      next_page_url: nil,
      client: client
    )

    assert_equal 1, collection.count(alice)
  end

  def test_next_page_returns_next_collection
    next_data = [Calendlyr::Object.new(name: "Charlie")]
    next_collection = Calendlyr::Collection.new(
      data: next_data, count: 1, next_page_url: nil, client: client
    )
    caller_lambda = ->(page_token:) { next_collection }

    collection = Calendlyr::Collection.new(
      data: [Calendlyr::Object.new(name: "Alice")],
      count: 1,
      next_page_url: "https://api.calendly.com/scheduled_events?page_token=TOKEN123",
      client: client,
      next_page_caller: caller_lambda
    )

    result = collection.next_page

    assert_equal next_collection, result
    assert_equal Calendlyr::Collection, result.class
  end

  def test_next_page_returns_nil_when_no_token
    collection = Calendlyr::Collection.new(
      data: [Calendlyr::Object.new(name: "Alice")],
      count: 1,
      next_page_url: nil,
      client: client,
      next_page_caller: ->(page_token:) { raise "should not be called" }
    )

    assert_nil collection.next_page
  end

  def test_next_page_returns_nil_when_no_caller
    collection = Calendlyr::Collection.new(
      data: [Calendlyr::Object.new(name: "Alice")],
      count: 1,
      next_page_url: "https://api.calendly.com/scheduled_events?page_token=TOKEN123",
      client: client
    )

    assert_nil collection.next_page
  end

  def test_auto_paginate_yields_all_items_across_pages
    page3_data = [Calendlyr::Object.new(name: "Charlie")]
    page3 = Calendlyr::Collection.new(
      data: page3_data, count: 1, next_page_url: nil, client: client
    )

    page2_data = [Calendlyr::Object.new(name: "Bob")]
    page2 = Calendlyr::Collection.new(
      data: page2_data, count: 1,
      next_page_url: "https://api.calendly.com/events?page_token=P3",
      client: client,
      next_page_caller: ->(page_token:) { page3 }
    )

    page1_data = [Calendlyr::Object.new(name: "Alice")]
    page1 = Calendlyr::Collection.new(
      data: page1_data, count: 1,
      next_page_url: "https://api.calendly.com/events?page_token=P2",
      client: client,
      next_page_caller: ->(page_token:) { page2 }
    )

    result = page1.auto_paginate.to_a

    assert_equal %w[Alice Bob Charlie], result.map(&:name)
  end

  def test_auto_paginate_empty_collection
    collection = Calendlyr::Collection.new(
      data: [], count: 0, next_page_url: nil, client: client
    )

    assert_equal [], collection.auto_paginate.to_a
  end

  def test_auto_paginate_lazy_does_not_prefetch
    page2_called = false

    page2_data = [Calendlyr::Object.new(name: "Bob")]
    page2 = Calendlyr::Collection.new(
      data: page2_data, count: 1, next_page_url: nil, client: client
    )

    page1_data = [Calendlyr::Object.new(name: "Alice")]
    page1 = Calendlyr::Collection.new(
      data: page1_data, count: 1,
      next_page_url: "https://api.calendly.com/events?page_token=P2",
      client: client,
      next_page_caller: lambda { |page_token:|
        page2_called = true
        page2
      }
    )

    result = page1.auto_paginate.first(1)

    assert_equal ["Alice"], result.map(&:name)
    refute page2_called, "Page 2 lambda should NOT have been called"
  end
end
