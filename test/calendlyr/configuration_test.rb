require "test_helper"
require "logger"
require "stringio"

class ConfigurationTest < Minitest::Test
  def test_readme_documents_multi_tenant_caveat
    readme = File.read(File.expand_path("../../README.md", __dir__))

    assert_includes readme, "not thread-safe for multi-tenant usage"
    assert_includes readme, "use `Calendlyr::Client.new(token:)` per request"
  end

  def test_readme_documents_optional_logging
    readme = File.read(File.expand_path("../../README.md", __dir__))

    assert_includes readme, "config.logger = Logger.new($stdout)"
    assert_includes readme, "Calendlyr::Client.new(token: ENV[\"CALENDLY_TOKEN\"], logger: Logger.new($stdout))"
  end

  def test_configuration_returns_defaults_before_configure
    configuration = Calendlyr.configuration

    assert_instance_of Calendlyr::Configuration, configuration
    assert_nil configuration.token
    assert_nil configuration.logger
    assert_equal 30, configuration.open_timeout
    assert_equal 30, configuration.read_timeout
  end

  def test_configure_sets_values
    Calendlyr.configure do |config|
      config.token = "tk"
      config.open_timeout = 5
    end

    assert_equal "tk", Calendlyr.configuration.token
    assert_equal 5, Calendlyr.configuration.open_timeout
    assert_equal 30, Calendlyr.configuration.read_timeout
  end

  def test_successive_configure_calls_merge
    Calendlyr.configure { |config| config.token = "a" }
    Calendlyr.configure { |config| config.open_timeout = 10 }

    assert_equal "a", Calendlyr.configuration.token
    assert_equal 10, Calendlyr.configuration.open_timeout
  end

  def test_client_is_memoized_when_configuration_does_not_change
    Calendlyr.configure { |config| config.token = "tk" }

    first_client = Calendlyr.client
    second_client = Calendlyr.client

    assert_equal first_client.object_id, second_client.object_id
    assert_equal "tk", first_client.token
  end

  def test_client_propagates_timeout_configuration
    Calendlyr.configure do |config|
      config.token = "tk"
      config.read_timeout = 15
    end

    assert_equal 15, Calendlyr.client.read_timeout
  end

  def test_client_without_token_mentions_configure_in_error
    error = assert_raises(ArgumentError) { Calendlyr.client }

    assert_includes error.message, "Calendlyr.configure"
  end

  def test_reconfigure_invalidates_client_cache
    Calendlyr.configure { |config| config.token = "old" }
    first_client = Calendlyr.client

    Calendlyr.configure { |config| config.token = "new" }
    second_client = Calendlyr.client

    assert_equal "new", second_client.token
    refute_equal first_client.object_id, second_client.object_id
  end

  def test_reconfigure_timeout_invalidates_client_cache
    Calendlyr.configure { |config| config.token = "tk" }
    first_client = Calendlyr.client

    Calendlyr.configure { |config| config.read_timeout = 10 }
    second_client = Calendlyr.client

    assert_equal 10, second_client.read_timeout
    refute_equal first_client.object_id, second_client.object_id
  end

  def test_configure_sets_logger_and_propagates_to_client
    logger = Logger.new(StringIO.new)

    Calendlyr.configure do |config|
      config.token = "tk"
      config.logger = logger
    end

    assert_equal logger, Calendlyr.configuration.logger
    assert_equal logger, Calendlyr.client.logger
  end

  def test_reconfigure_logger_invalidates_client_cache
    Calendlyr.configure { |config| config.token = "tk" }
    first_client = Calendlyr.client

    logger = Logger.new(StringIO.new)
    Calendlyr.configure { |config| config.logger = logger }
    second_client = Calendlyr.client

    assert_equal logger, second_client.logger
    refute_equal first_client.object_id, second_client.object_id
  end

  def test_logger_defaults_to_nil_after_reset
    Calendlyr.configure do |config|
      config.token = "tk"
      config.logger = Logger.new(StringIO.new)
    end

    Calendlyr.reset!

    assert_nil Calendlyr.configuration.logger
  end

  def test_reset_clears_configuration_and_client
    Calendlyr.configure { |config| config.token = "tk" }
    Calendlyr.client

    Calendlyr.reset!

    assert_nil Calendlyr.configuration.token
    assert_raises(ArgumentError) { Calendlyr.client }
  end

  def test_explicit_client_ignores_global_configuration
    Calendlyr.configure { |config| config.token = "global" }

    explicit_client = Calendlyr::Client.new(token: "explicit")

    assert_equal "explicit", explicit_client.token
    assert_equal "global", Calendlyr.client.token
  end

  def test_explicit_client_works_without_global_configuration
    Calendlyr.reset!

    explicit_client = Calendlyr::Client.new(token: "standalone")

    assert_equal "standalone", explicit_client.token
  end
end
