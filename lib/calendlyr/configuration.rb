module Calendlyr
  class Configuration
    attr_accessor :token, :open_timeout, :read_timeout

    def initialize(token: nil, open_timeout: nil, read_timeout: nil)
      @token = token
      @open_timeout = open_timeout.nil? ? self.class.default_open_timeout : open_timeout
      @read_timeout = read_timeout.nil? ? self.class.default_read_timeout : read_timeout
    end

    def self.default_open_timeout
      Calendlyr::Client::DEFAULT_OPEN_TIMEOUT
    rescue NameError
      30
    end

    def self.default_read_timeout
      Calendlyr::Client::DEFAULT_READ_TIMEOUT
    rescue NameError
      30
    end
  end
end
