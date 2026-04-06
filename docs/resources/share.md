# Share Calendlyr::Share

Share Object.

Visit official [API Doc](https://developer.calendly.com/api-docs/0069948603238-share)


## Client requests

### Create

Endpoint for our Customize Once and Share feature. This allows you to customize events for a specific invitee without needing to make an entirely new event type. This feature is only available for one-on-one event types. Note: Any parameter which is not provided in the request body will be copied from the target event type.

Visit official [API Doc](https://developer.calendly.com/api-docs/fdcac06abfc8c-create-share)

```ruby
# event_type: accepts a bare UUID or full Calendly URI
client.shares.create(event_type: "EVENT_TYPE_UUID", name: "15 minute meeting", duration: ...)
#=> #<Calendlyr::Share>
```

## Object methods
