# frozen_string_literal: true

require "json"
require "openssl"

module Calendlyr
  module Webhook
    DEFAULT_TOLERANCE = 300

    module_function

    def verify!(payload:, signing_key:, header: nil, signature_header: nil, tolerance: DEFAULT_TOLERANCE)
      raise ArgumentError, "signing_key is required" if signing_key.nil? || signing_key.empty?

      resolved_header = resolve_signature_header(header: header, signature_header: signature_header)
      timestamp, provided_signature = parse_header(resolved_header)
      verify_timestamp!(timestamp, tolerance)

      expected_signature = compute_signature(payload, timestamp, signing_key)
      return true if secure_compare?(expected_signature, provided_signature)

      raise WebhookSignatureError, "Invalid webhook signature"
    end

    def valid?(payload:, signing_key:, header: nil, signature_header: nil, tolerance: DEFAULT_TOLERANCE)
      verify!(payload: payload, header: header, signature_header: signature_header, signing_key: signing_key, tolerance: tolerance)
    rescue WebhookSignatureError, WebhookTimestampError
      false
    end

    def parse(payload:, signing_key:, header: nil, signature_header: nil, tolerance: DEFAULT_TOLERANCE)
      verify!(payload: payload, header: header, signature_header: signature_header, signing_key: signing_key, tolerance: tolerance)
      parsed_payload = JSON.parse(payload)
      Webhooks::Payload.new(parsed_payload.merge(client: nil))
    end

    def resolve_signature_header(header:, signature_header:)
      if header && signature_header && header != signature_header
        raise ArgumentError, "Provide either header or signature_header"
      end

      header || signature_header
    end
    private_class_method :resolve_signature_header

    def parse_header(header)
      raise WebhookSignatureError, "Missing webhook signature header" if header.nil? || header.strip.empty?

      pairs = header.split(",").map(&:strip)
      parsed = Hash.new { |hash, key| hash[key] = [] }

      pairs.each do |pair|
        key, value = pair.split("=", 2)
        raise WebhookSignatureError, "Malformed webhook signature header" if key.nil? || value.nil?

        parsed[key] << value.strip
      end

      timestamp_value = extract_single!(parsed, "t")
      signature_value = extract_single!(parsed, "v1")

      raise WebhookSignatureError, "Malformed webhook timestamp" unless timestamp_value.match?(/\A\d+\z/)

      normalized_signature = signature_value.downcase
      raise WebhookSignatureError, "Malformed webhook signature" unless normalized_signature.match?(/\A\h{64}\z/)

      [timestamp_value.to_i, normalized_signature]
    end
    private_class_method :parse_header

    def extract_single!(parsed, key)
      values = parsed[key]
      raise WebhookSignatureError, "Missing #{key} in webhook signature header" if values.empty?
      raise WebhookSignatureError, "Duplicate #{key} in webhook signature header" if values.size > 1

      value = values.first
      raise WebhookSignatureError, "Blank #{key} in webhook signature header" if value.nil? || value.empty?

      value
    end
    private_class_method :extract_single!

    def verify_timestamp!(timestamp, tolerance)
      return if tolerance.nil?

      age = Time.now.to_i - timestamp
      return if age.abs <= tolerance

      raise WebhookTimestampError, "Webhook timestamp outside tolerance"
    end
    private_class_method :verify_timestamp!

    def compute_signature(payload, timestamp, signing_key)
      OpenSSL::HMAC.hexdigest("SHA256", signing_key, "#{timestamp}.#{payload}")
    end
    private_class_method :compute_signature

    def secure_compare?(expected_signature, provided_signature)
      return false unless expected_signature.bytesize == provided_signature.bytesize

      OpenSSL.fixed_length_secure_compare(expected_signature, provided_signature)
    end
    private_class_method :secure_compare?
  end
end
