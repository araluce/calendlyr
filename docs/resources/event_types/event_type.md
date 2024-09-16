# Event Type Calendlyr::EventType

A configuration for an Event.

Visit official [API Doc](https://developer.calendly.com/api-docs/f3185c91567db-event-type)

## Client requests

### Retrieve

Returns information about a specified Event Type.

Visit official [API Doc](https://developer.calendly.com/api-docs/c1f9db4a585da-get-event-type)

```ruby
client.event_types.retrieve(uuid: @uuid)
#=> #<Calendlyr::EventType>
```

### List
Returns all Event Types associated with a specified User.

Visit official [API Doc](https://developer.calendly.com/api-docs/25a4ece03c1bc-list-user-s-event-types)

For the examples bellow we will use only required parameters, but you can use any other parameter as well.
```ruby
client.event_types.list(user: @user)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventType>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>

client.event_types.list(organization: @organization)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventType>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Profile

```ruby
event_type.associated_profile
#=> #<Calendlyr::EventTypes::Profile>
```

### Create Share

```ruby
event_type.create_share
#=> #<Calendlyr::Share>
```

### Available Times

```ruby
event_type.available_times(start_time: @start_time, end_time: @end_time, ...)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::AvailableTime>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
