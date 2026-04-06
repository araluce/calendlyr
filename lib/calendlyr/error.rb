module Calendlyr
  class Error < StandardError
    attr_reader :status, :http_method, :path, :response_body

    def initialize(message = nil, status: nil, http_method: nil, path: nil, response_body: nil)
      @status = status
      @http_method = http_method
      @path = path
      @response_body = response_body
      super(message)
    end
  end

  class PaymentRequired < Error; end

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
    def initialize(code, body, method: nil, path: nil)
      @code = code
      @body = body
      @method = method
      @path = path
    end

    def error
      return too_many_requests_error if @code == "429"

      error_type.new(
        message,
        status: @code,
        http_method: @method,
        path: @path,
        response_body: @body
      )
    end

    private

    def error_type
      return PaymentRequired if @code == "403" && @body.fetch("message", "").include?("upgrade")

      klass = "Calendlyr::#{Calendlyr::ERROR_TYPES[@code]}"
      Calendlyr.const_get(klass)
    end

    def too_many_requests_error
      error_type.new(
        contextual_message("Too many requests, please try again later."),
        status: @code,
        http_method: @method,
        path: @path,
        response_body: @body
      )
    end

    def message
      contextual_message(body_message)
    end

    def body_message
      [@body["title"], @body["message"]].compact.reject(&:empty?).join(". ")
    end

    def contextual_message(body_message)
      base = "[Error #{@code}]"
      return [base, body_message].reject(&:empty?).join(" ") unless @method && @path

      path = @path.start_with?("/") ? @path : "/#{@path}"
      context = "#{@method} #{path}"
      return "#{base} #{context}" if body_message.empty?

      "#{base} #{context} — #{body_message}"
    end
  end
end
