require "test_helper"

class ObjectTest < Minitest::Test
  def test_creating_object_from_hash
    assert_equal "bar", Calendlyr::Object.new(foo: "bar").foo
  end

  def test_nested_hash
    assert_equal "foobar", Calendlyr::Object.new(foo: {bar: {baz: "foobar"}}, client: nil).foo.bar.baz
  end

  def test_nested_number
    assert_equal 1, Calendlyr::Object.new(foo: {bar: 1}, client: nil).foo.bar
  end

  def test_array
    object = Calendlyr::Object.new(foo: [{bar: :baz}], client: nil)
    assert_equal Calendlyr::Object, object.foo.first.class
    assert_equal :baz, object.foo.first.bar
  end

  def test_uuid_extraction_from_string_uri
    object = Calendlyr::Object.new("uri" => "https://api.calendly.com/users/ABC123")

    assert_equal "ABC123", object.uuid
  end

  def test_missing_attribute_returns_nil
    object = Calendlyr::Object.new(name: "test")

    assert_nil object.nonexistent
  end

  def test_respond_to_existing_attribute
    object = Calendlyr::Object.new(name: "test")

    assert object.respond_to?(:name)
  end

  def test_to_h_returns_deep_hash
    object = Calendlyr::Object.new("profile" => {"age" => 30, "items" => [{"id" => 1}]})

    assert_equal({profile: {age: 30, items: [{id: 1}]}, uuid: nil}, object.to_h)
  end

  def test_equals_other_object_with_same_attributes
    first = Calendlyr::Object.new(name: "test")
    second = Calendlyr::Object.new(name: "test")

    assert_equal first, second
  end

  def test_to_h_excludes_client_key
    object = Calendlyr::Object.new(name: "test", client: :some_client)

    refute object.to_h.key?(:client)
  end

  def test_to_h_client_dot_access_still_works
    object = Calendlyr::Object.new(name: "test", client: :some_client)

    assert_equal :some_client, object.client
  end

  def test_to_json_returns_valid_json_string
    object = Calendlyr::Object.new(name: "test", status: "active", client: :some_client)
    parsed = JSON.parse(object.to_json)

    assert_equal "test", parsed["name"]
    assert_equal "active", parsed["status"]
    refute parsed.key?("client")
  end

  def test_to_json_nested_objects_and_arrays
    object = Calendlyr::Object.new(user: {name: "alice"}, items: [{id: 1}])
    parsed = JSON.parse(object.to_json)

    assert_equal "alice", parsed["user"]["name"]
    assert_equal 1, parsed["items"][0]["id"]
  end

  def test_to_json_nil_values_become_null
    object = Calendlyr::Object.new(name: nil)
    parsed = JSON.parse(object.to_json)

    assert parsed.key?("name")
    assert_nil parsed["name"]
  end

  def test_json_generate_compatibility
    object = Calendlyr::Object.new(name: "test")

    assert_equal object.to_json, JSON.generate(object)
  end

  def test_round_trip_equivalence
    original = Calendlyr::Object.new(name: "alice", status: "active")
    round_tripped = Calendlyr::Object.new(JSON.parse(original.to_json))

    assert_equal original, round_tripped
  end
end
