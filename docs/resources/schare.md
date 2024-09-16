# Share Calendlyr::Schare

Schare Object.

Visit official [API Doc](https://developer.calendly.com/api-docs/0069948603238-share)


## Client requests

### Create

Endpoint for our Customize Once and Share feature. This allows you to customize events for a specific invitee without needing to make an entirely new event type. This feature is only available for one-on-one event types. Note: Any parameter which is not provided in the request body will be copied from the target event type.

Visit official [API Doc](https://developer.calendly.com/api-docs/fdcac06abfc8c-create-share)

```ruby
client.shares.create(create: event_type_uri, name: "15 minute meeting", duration: ...)
#=> #<Calendlyr::Share>
```

## Object methods

### Associated Scheduling Links

```ruby
share.associated_scheduling_links
#=> [#<Calendlyr::SchedulingLink>]
```
