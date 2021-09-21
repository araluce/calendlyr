require "test_helper"

class ObjectTest < Minitest::Test
  def test_creating_object_from_hash
    assert_equal "bar", Calendly::Object.new(foo: "bar").foo
  end

  def test_nested_hash
    assert_equal "foobar", Calendly::Object.new(foo: {bar: {baz: "foobar"}}, client: nil).foo.bar.baz
  end

  def test_nested_number
    assert_equal 1, Calendly::Object.new(foo: {bar: 1}, client: nil).foo.bar
  end

  def test_array
    object = Calendly::Object.new(foo: [{bar: :baz}], client: nil)
    assert_equal OpenStruct, object.foo.first.class
    assert_equal :baz, object.foo.first.bar
  end
end
