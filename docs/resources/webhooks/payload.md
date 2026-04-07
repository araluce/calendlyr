# Webhooks Payload (`Calendlyr::Webhooks::Payload`)

`Calendlyr::Webhooks::Payload` is the object returned by `Calendlyr::Webhook.parse` after signature verification.

`Calendlyr::Webhook` expects:
- `payload:` raw request body string
- `signing_key:` your Calendly webhook signing key
- one signature header keyword: `signature_header:` (preferred) or `header:` (backward compatible)

`verify!` raises on invalid signature/timestamp, `valid?` returns boolean, and `parse` verifies first then parses JSON.

## Signed payload verification + parsing

```ruby
payload = request.body.read
signature_header = request.get_header("HTTP_CALENDLY_WEBHOOK_SIGNATURE")
signing_key = ENV.fetch("CALENDLY_WEBHOOK_SIGNING_KEY")

Calendlyr::Webhook.verify!(payload: payload, signature_header: signature_header, signing_key: signing_key)
parsed = Calendlyr::Webhook.parse(payload: payload, signature_header: signature_header, signing_key: signing_key)

parsed.event
#=> "invitee.created"

parsed.payload
#=> #<Calendlyr::Webhooks::InviteePayload ...> for invitee.* events
#=> #<Calendlyr::Object ...> for unknown events
```

> `Calendlyr::Webhook` (singular) handles signature verification.
> `Calendlyr::Webhooks` (plural) contains API resource objects and payload wrappers.
> Calendly's header is `Calendly-Webhook-Signature`; in Rack/Rails, read `HTTP_CALENDLY_WEBHOOK_SIGNATURE`.

Visit official [API Doc](https://developer.calendly.com/api-docs/69c58da556b61-webhook-payload).
