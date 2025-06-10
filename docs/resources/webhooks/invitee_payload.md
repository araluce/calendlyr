# Webhooks Invitee Payload Calendlyr::Wehooks::InviteePayload

The payload that is sent via Webhook when an invitee creates or schedules a meeting, and when an invitee cancels.

Visit official [API Doc](https://developer.calendly.com/api-docs/b92768854bc06-invitee-payload)

## Object methods

### Associated Event

```ruby
webhook_invitee_payload.associated_organization
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

### active?

```ruby
webhook_subscription.active?
#=> true
```

### disabled?

```ruby
webhook_subscription.disabled?
#=> false
```
