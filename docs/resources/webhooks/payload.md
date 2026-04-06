# Webhooks Payload (`Calendlyr::Webhooks::Payload`)

`Calendlyr::Webhooks::Payload` is the typed object returned by `Calendlyr::Webhook.parse` after signature verification.

## Signed payload verification + parsing

```ruby
payload = request.body.read
header = request.get_header("HTTP_CALENDLY_WEBHOOK_SIGNATURE")
signing_key = ENV.fetch("CALENDLY_WEBHOOK_SIGNING_KEY")

Calendlyr::Webhook.verify!(payload: payload, header: header, signing_key: signing_key)
parsed = Calendlyr::Webhook.parse(payload: payload, header: header, signing_key: signing_key)

parsed.event
#=> "invitee.created"

parsed.payload
#=> #<Calendlyr::Webhooks::InviteePayload ...> for invitee.* events
#=> #<Calendlyr::Object ...> for unknown events
```

> `Calendlyr::Webhook` (singular) handles signature verification.
> `Calendlyr::Webhooks` (plural) contains API resource objects and payload wrappers.

Visit official [API Doc](https://developer.calendly.com/api-docs/69c58da556b61-webhook-payload).
