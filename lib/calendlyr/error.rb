module Calendlyr
  class Error < StandardError; end
  class PermissionDenied < StandardError; end
  class BadRequest < StandardError; end
  class PaymentRequired < StandardError; end
  class Unauthenticated < StandardError; end
  class NotFound < StandardError; end
  class ExternalCalendarEror < StandardError; end
  class InternalServerError < StandardError; end

  class ResponseErrorHandler
    ERROR_TYPES = {
      "400" => BadRequest,
      "401" => Unauthenticated,
      "403" => PermissionDenied,
      "404" => NotFound,
      "424" => ExternalCalendarEror,
      "500" => InternalServerError,
    }

    def initialize(code, body)
      @code = code
      @body = body
    end

    def error
      error_type.new("[Error #{@code}] #{@body["title"]}. #{@body["message"]}")
    end

    private

    def error_type
      return PaymentRequired if @code == "403" && @body["message"].include?("upgrade")

      ERROR_TYPES[@code]
    end
  end
end
