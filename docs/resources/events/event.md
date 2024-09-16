# Event Calendlyr::Event

Information about a scheduled meeting.

Visit official [API Doc](https://developer.calendly.com/api-docs/504508461e486-event)

## Client requests

### Retrieve

Returns information about a specified Event.

Visit official [API Doc](https://developer.calendly.com/api-docs/e2f95ebd44914-get-event)

```ruby
client.events.retrieve(uuid: uuid)
#=> #<Calendlyr::Event>
```

### List

Returns a list of Events.

Visit official [API Doc](https://developer.calendly.com/api-docs/2d5ed9bbd2952-list-events)

```ruby
client.events.list(organization: organization, user: user)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>

client.events.list(organization: organization, group: group)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>

client.events.list(user: user)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Cancel

Cancels specified event.

Visit official [API Doc](https://developer.calendly.com/api-docs/afb2e9fe3a0a0-cancel-event)

```ruby
client.events.cancel(uuid: event_uuid, reason: "I'm bussy")
#=> #<Calendlyr::Events::Cancellation>
```

## Object methods

### Memberships

```ruby
event.memberships
#=> [#<Calendlyr::User>, ...]
```

### Cancel

```ruby
event.cancel(reason: "I'm bussy")
#=> #<Calendlyr::Events::Cancellation>
```
