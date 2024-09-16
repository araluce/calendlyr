# Cancellation Calendlyr::Events::Cancellation

Provides data pertaining to the cancellation of the Event or the Invitee.

Visit official [API Doc](https://developer.calendly.com/api-docs/77497aba237ee-cancellation)

## Client requests

### Cancel event

Cancels specified event.

Visit official [API Doc](https://developer.calendly.com/api-docs/afb2e9fe3a0a0-cancel-event)

```ruby
client.events.cancel(uuid: event_uuid, reason: "I'm bussy")
#=> #<Calendlyr::Events::Cancellation>
```
