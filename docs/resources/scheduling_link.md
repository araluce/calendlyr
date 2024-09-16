# Scheduling Link Calendlyr::SchedulingLink

Scheduling Link Object.


## Client requests

### Create

Creates a single-use scheduling link.

Visit official [API Doc](https://developer.calendly.com/api-docs/4b8195084e287-create-single-use-scheduling-link)

```ruby
client.scheduling_links.create(owner: event_type_uri, max_event_count: 1)
#=> #<Calendlyr::SchedulingLink>
```

## Object methods

### Event Type

```ruby
scheduling_link.event_type
#=> #<Calendlyr::EventType>
```
