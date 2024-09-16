# User Calendlyr::User

Information about the user.

Visit official [API Doc](https://developer.calendly.com/api-docs/647961f90c0dd-user)

## Client requests

### Retrieve

Returns information about a specified User.

Visit official [API Doc](https://developer.calendly.com/api-docs/ff9832c5a6640-get-user)

```ruby
client.users.retrieve(uuid: user_uuid)
#=> #<Calendlyr::User>
```

### Me

Returns basic information about your user account.

Visit official [API Doc](https://developer.calendly.com/api-docs/005832c83aeae-get-current-user)

```ruby
client.users.me
#=> #<Calendlyr::User>
```

#### Easy access

Probably you need to make many calls through `client.me`, so we decided to not make calls for every `client.me` reference by memoizing it the first time.

```ruby
client.me # makes a call and memoize the response
client.me # no call, value memoized
```

#### Force reload

However, if you need to reload the content of `me` you can `force_relaod` to force a new call.

```ruby
client.me(force_reload: true) # makes a new call and update memoized value
```

## Object methods

### Associated Organization

```ruby
user.associated_organization
#=> #<Calendlyr::Organization>
```

### Availability Schedules

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
user.availability_schedules
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserSchedule>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Memberships

Based on your user organization

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
user.memberships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Membership>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Organization Membership

Based on your user organization

```ruby
user.membership(uuid: membership_uuid)
#=> #<Calendlyr::Organizations::Membership>
```

### Event Types

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
user.event_types
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventType>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Events

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
user.events
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Busy Times

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
user.busy_times(start_time: start_time, end_time: end_time)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserBusyTime>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
