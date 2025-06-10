module Calendlyr
  class Error < StandardError; end

  class PaymentRequired < StandardError; end

  ERROR_TYPES = {
    "400" => "BadRequest",
    "401" => "Unauthenticated",
    "403" => "PermissionDenied",
    "404" => "NotFound",
    "424" => "ExternalCalendarError",
    "429" => "TooManyRequests",
    "500" => "InternalServerError"
  }

  ERROR_TYPES.values.each do |error_class|
    Calendlyr.const_set(error_class, Class.new(Error))
  end

  class ResponseErrorHandler
    def initialize(code, body)
      @code = code
      @body = body
    end

    def error
      return too_many_requests_error if @code == "429"

      error_type.new("[Error #{@code}] #{@body["title"]}. #{@body["message"]}")
    end

    private

    def error_type
      return PaymentRequired if @code == "403" && @body["message"].include?("upgrade")

      klass = "Calendlyr::#{Calendlyr::ERROR_TYPES[@code]}"
      Calendlyr.const_get(klass)
    end

    def too_many_requests_error
      error_type.new("[Error #{@code}] Too many requests, please try again later.")
    end
  end
end
