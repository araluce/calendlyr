# frozen_string_literal: true

require "test_helper"
require "openssl"

class WebhookTest < Minitest::Test
  SIGNING_KEY = "webhook-signing-secret"
  ZERO_SIGNATURE = "0" * 64
  A_SIGNATURE = "a" * 64

  def test_autoloads_webhook_and_new_error_types
    assert_equal Calendlyr::Webhook, Calendlyr::Webhook
    assert_equal Calendlyr::Error, Calendlyr::WebhookSignatureError.superclass
    assert_equal Calendlyr::Error, Calendlyr::WebhookTimestampError.superclass
  end

  def test_verify_bang_accepts_valid_header_with_whitespace_and_unknown_keys
    payload = fixture_file("objects/webhooks/payload")
    timestamp = 1_700_000_000
    signature = sign(payload: payload, timestamp: timestamp)
    header = " foo=bar, t=#{timestamp} , v1=#{signature} "

    assert Time.stub(:now, Time.at(timestamp)) {
      Calendlyr::Webhook.verify!(payload: payload, header: header, signing_key: SIGNING_KEY)
    }
  end

  def test_verify_bang_accepts_signature_header_alias
    payload = fixture_file("objects/webhooks/payload")
    timestamp = 1_700_000_000

    assert Time.stub(:now, Time.at(timestamp)) {
      Calendlyr::Webhook.verify!(
        payload: payload,
        signature_header: signed_header(payload: payload, timestamp: timestamp),
        signing_key: SIGNING_KEY
      )
    }
  end

  def test_verify_bang_raises_argument_error_for_conflicting_header_args
    payload = fixture_file("objects/webhooks/payload")

    assert_raises(ArgumentError) do
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: "t=1700000000,v1=#{A_SIGNATURE}",
        signature_header: "t=1700000000,v1=#{ZERO_SIGNATURE}",
        signing_key: SIGNING_KEY,
        tolerance: nil
      )
    end
  end

  def test_verify_bang_raises_when_header_is_missing
    payload = fixture_file("objects/webhooks/payload")

    assert_raises(Calendlyr::WebhookSignatureError) do
      Calendlyr::Webhook.verify!(payload: payload, header: nil, signing_key: SIGNING_KEY)
    end

    assert_raises(Calendlyr::WebhookSignatureError) do
      Calendlyr::Webhook.verify!(payload: payload, header: "", signing_key: SIGNING_KEY)
    end
  end

  def test_verify_bang_raises_for_malformed_missing_duplicate_or_blank_t_and_v1
    payload = fixture_file("objects/webhooks/payload")

    invalid_headers = [
      "v1=abcdef",
      "t=1700000000",
      "t=1700000000,t=1700000001,v1=#{sign(payload: payload, timestamp: 1_700_000_000)}",
      "t=1700000000,v1=#{sign(payload: payload, timestamp: 1_700_000_000)},v1=abcd",
      "t=,v1=abcd",
      "t=1700000000,v1=",
      "invalid-segment"
    ]

    invalid_headers.each do |header|
      assert_raises(Calendlyr::WebhookSignatureError) do
        Calendlyr::Webhook.verify!(payload: payload, header: header, signing_key: SIGNING_KEY)
      end
    end
  end

  def test_verify_bang_returns_true_for_valid_signature
    payload = fixture_file("objects/webhooks/payload")
    timestamp = 1_700_000_000

    assert Time.stub(:now, Time.at(timestamp)) {
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: signed_header(payload: payload, timestamp: timestamp),
        signing_key: SIGNING_KEY
      )
    }
  end

  def test_verify_bang_raises_for_invalid_or_mismatched_signature
    payload = fixture_file("objects/webhooks/payload")

    assert_raises(Calendlyr::WebhookSignatureError) do
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: "t=1700000000,v1=#{ZERO_SIGNATURE}",
        signing_key: SIGNING_KEY,
        tolerance: nil
      )
    end

    assert_raises(Calendlyr::WebhookSignatureError) do
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: "t=1700000000,v1=abc",
        signing_key: SIGNING_KEY,
        tolerance: nil
      )
    end
  end

  def test_verify_bang_raises_argument_error_for_missing_signing_key
    payload = fixture_file("objects/webhooks/payload")

    assert_raises(ArgumentError) do
      Calendlyr::Webhook.verify!(payload: payload, header: "t=1700000000,v1=#{A_SIGNATURE}", signing_key: nil)
    end

    assert_raises(ArgumentError) do
      Calendlyr::Webhook.verify!(payload: payload, header: "t=1700000000,v1=#{A_SIGNATURE}", signing_key: "")
    end
  end

  def test_verify_bang_enforces_default_tolerance_when_timestamp_is_expired
    payload = fixture_file("objects/webhooks/payload")
    now = 1_700_000_400
    expired_timestamp = now - 301

    assert_raises(Calendlyr::WebhookTimestampError) do
      Time.stub(:now, Time.at(now)) do
        Calendlyr::Webhook.verify!(
          payload: payload,
          header: signed_header(payload: payload, timestamp: expired_timestamp),
          signing_key: SIGNING_KEY
        )
      end
    end
  end

  def test_verify_bang_passes_within_default_tolerance
    payload = fixture_file("objects/webhooks/payload")
    now = 1_700_000_400
    fresh_timestamp = now - 299

    assert Time.stub(:now, Time.at(now)) {
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: signed_header(payload: payload, timestamp: fresh_timestamp),
        signing_key: SIGNING_KEY
      )
    }
  end

  def test_verify_bang_skips_timestamp_check_when_tolerance_is_nil
    payload = fixture_file("objects/webhooks/payload")
    now = 1_700_000_400
    old_timestamp = now - 10_000

    assert Time.stub(:now, Time.at(now)) {
      Calendlyr::Webhook.verify!(
        payload: payload,
        header: signed_header(payload: payload, timestamp: old_timestamp),
        signing_key: SIGNING_KEY,
        tolerance: nil
      )
    }
  end

  def test_valid_returns_boolean_and_rescues_only_webhook_errors
    payload = fixture_file("objects/webhooks/payload")
    now = 1_700_000_400
    expired_timestamp = now - 301

    assert Time.stub(:now, Time.at(now)) {
      Calendlyr::Webhook.valid?(
        payload: payload,
        header: signed_header(payload: payload, timestamp: now),
        signing_key: SIGNING_KEY
      )
    }

    refute Calendlyr::Webhook.valid?(
      payload: payload,
      header: "t=1700000000,v1=#{ZERO_SIGNATURE}",
      signing_key: SIGNING_KEY,
      tolerance: nil
    )

    refute Time.stub(:now, Time.at(now)) {
      Calendlyr::Webhook.valid?(
        payload: payload,
        header: signed_header(payload: payload, timestamp: expired_timestamp),
        signing_key: SIGNING_KEY
      )
    }

    assert_raises(ArgumentError) do
      Calendlyr::Webhook.valid?(payload: payload, header: signed_header(payload: payload, timestamp: now), signing_key: nil)
    end
  end

  def test_valid_accepts_signature_header_alias
    payload = fixture_file("objects/webhooks/payload")
    now = 1_700_000_400

    assert Time.stub(:now, Time.at(now)) {
      Calendlyr::Webhook.valid?(
        payload: payload,
        signature_header: signed_header(payload: payload, timestamp: now),
        signing_key: SIGNING_KEY
      )
    }
  end

  def test_parse_returns_typed_payload_after_signature_verification
    payload = fixture_file("objects/webhooks/payload")
    timestamp = 1_700_000_000

    parsed = Time.stub(:now, Time.at(timestamp)) {
      Calendlyr::Webhook.parse(
        payload: payload,
        header: signed_header(payload: payload, timestamp: timestamp),
        signing_key: SIGNING_KEY
      )
    }

    assert_instance_of Calendlyr::Webhooks::Payload, parsed
    assert_equal "invitee.created", parsed.event
    assert_instance_of Calendlyr::Webhooks::InviteePayload, parsed.payload
  end

  def test_parse_accepts_signature_header_alias
    payload = fixture_file("objects/webhooks/payload")
    timestamp = 1_700_000_000

    parsed = Time.stub(:now, Time.at(timestamp)) {
      Calendlyr::Webhook.parse(
        payload: payload,
        signature_header: signed_header(payload: payload, timestamp: timestamp),
        signing_key: SIGNING_KEY
      )
    }

    assert_instance_of Calendlyr::Webhooks::Payload, parsed
  end

  def test_parse_raises_signature_error_before_parsing
    assert_raises(Calendlyr::WebhookSignatureError) do
      Calendlyr::Webhook.parse(
        payload: "{not-json}",
        header: "t=1700000000,v1=#{ZERO_SIGNATURE}",
        signing_key: SIGNING_KEY,
        tolerance: nil
      )
    end
  end

  def test_parse_bubbles_json_parser_error_after_successful_verification
    payload = "{not-json}"
    timestamp = 1_700_000_000

    assert_raises(JSON::ParserError) do
      Time.stub(:now, Time.at(timestamp)) do
        Calendlyr::Webhook.parse(
          payload: payload,
          header: signed_header(payload: payload, timestamp: timestamp),
          signing_key: SIGNING_KEY
        )
      end
    end
  end

  private

  def signed_header(payload:, timestamp:, signing_key: SIGNING_KEY)
    "t=#{timestamp},v1=#{sign(payload: payload, timestamp: timestamp, signing_key: signing_key)}"
  end

  def sign(payload:, timestamp:, signing_key: SIGNING_KEY)
    OpenSSL::HMAC.hexdigest("SHA256", signing_key, "#{timestamp}.#{payload}")
  end
end
