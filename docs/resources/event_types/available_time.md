# Available Time (`Calendlyr::EventTypes::AvailableTime`)

Available time for a specific Event Type in a given time window.

Visit official [API Doc](https://developer.calendly.com/api-docs)

## Client requests

### List Available Times

Returns available time slots for an Event Type between `start_time` and `end_time`.

Visit official [API Doc](https://developer.calendly.com/api-docs)

```ruby
# event_type: accepts a bare UUID or full Calendly URI
client.event_types.list_available_times(
  event_type: "EVENT_TYPE_UUID",
  start_time: "2026-04-07T09:00:00Z",
  end_time: "2026-04-07T18:00:00Z"
)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::AvailableTime>, ...], ...>
```

This endpoint does not support pagination.
