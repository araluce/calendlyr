# User Busy Time Calendlyr::Availabilities::UserBusyTime

An internal or external scheduled event for a given user.

Visit official [API Doc](https://developer.calendly.com/api-docs/acae53ca17454-user-busy-time)

## Client requests

### List

Visit official [API Doc](https://developer.calendly.com/api-docs/5920076156501-list-user-busy-times)

Date range can be no greater than 1 week (7 days).

For the example bellow we will use only required parameters, but you can use any other parameter as well.
```ruby
# user: accepts a bare UUID or full Calendly URI
client.availabilities.list_user_busy_times(user: "USER_UUID", start_time: start_time, end_time: end_time)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserBusyTime>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Event

```ruby
user_busy_time.associated_event
#=> #<Calendlyr::Event>
```
