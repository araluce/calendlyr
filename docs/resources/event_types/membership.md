# Event Type Membership (`Calendlyr::EventTypes::Membership`)

Membership object for an Event Type.

Visit official [API Doc](https://developer.calendly.com/api-docs)

## Client requests

### List

Returns memberships for a specified Event Type.

Visit official [API Doc](https://developer.calendly.com/api-docs)

```ruby
# event_type: accepts a bare UUID or full Calendly URI
client.event_types.list_memberships(event_type: "EVENT_TYPE_UUID")
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::Membership>, ...], ...>
```

### List All

Fetches every membership page and returns a flat Array.

```ruby
client.event_types.list_all_memberships(event_type: "EVENT_TYPE_UUID")
#=> [#<Calendlyr::EventTypes::Membership>, ...]
```
