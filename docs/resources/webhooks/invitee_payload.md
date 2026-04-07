# Webhooks Invitee Payload (`Calendlyr::Webhooks::InviteePayload`)

Typed payload wrapper used by `Calendlyr::Webhook.parse` when `event` is one of:
- `invitee.created`
- `invitee.canceled`
- `invitee_no_show.created`
- `invitee_no_show.deleted`

For other events, `parsed.payload` is returned as a generic `Calendlyr::Object`.

Visit official [API Doc](https://developer.calendly.com/api-docs/b92768854bc06-invitee-payload)

## Object methods

### Associated Event

```ruby
webhook_invitee_payload.associated_event
#=> #<Calendlyr::Event>
```

### Associated Routing Form Submission

```ruby
webhook_invitee_payload.associated_routing_form_submission
#=> #<Calendlyr::RoutingForms::Submission>
```

### Associated Invitee No Show

```ruby
webhook_invitee_payload.associated_invitee_no_show
#=> #<Calendlyr::Events::InviteeNoShow>
```

`active?` / `disabled?` are methods on `Calendlyr::Webhooks::Subscription`, not on invitee payloads.
