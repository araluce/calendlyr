# Membership (Host) Calendlyr::EventTypes::Membership

## Client requests

### List
Fetch list of event type hosts.

Visit official [API Doc](https://developer.calendly.com/api-docs/9e27c9bd793da-list-event-type-hosts)

```ruby
client.event_types.list_memberships(event_type, event_type)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::Membership>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Event Type

```ruby
membership.associated_event_type
#=> #<Calendlyr::EventType>
```

### Associated Member

```ruby
membership.associated_member
#=> [#<Calendlyr::User>, ...]
```
