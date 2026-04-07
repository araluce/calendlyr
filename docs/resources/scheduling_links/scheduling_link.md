# Scheduling Link (`Calendlyr::SchedulingLink`)

Scheduling link object.

Visit official [API Doc](https://developer.calendly.com/api-docs)

## Client requests

### Create

Creates a scheduling link for an Event Type owner.

Visit official [API Doc](https://developer.calendly.com/api-docs)

```ruby
# owner: accepts a bare UUID or full Calendly URI
client.scheduling_links.create(owner: "EVENT_TYPE_UUID")
#=> #<Calendlyr::SchedulingLink>

client.scheduling_links.create(
  owner: "EVENT_TYPE_UUID",
  owner_type: "EventType",
  max_event_count: 3
)
#=> #<Calendlyr::SchedulingLink>
```
