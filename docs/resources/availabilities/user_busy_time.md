# User Busy Time Calendlyr::Availabilities::UserBusyTime

An internal or external scheduled event for a given user.

Visit official [API Doc](https://developer.calendly.com/api-docs/acae53ca17454-user-busy-time)

## Client requests

### List

Visit official [API Doc](https://developer.calendly.com/api-docs/5920076156501-list-user-busy-times)

Date range can be no greater than 1 week (7 days).

For the example bellow we will use only required parameters, but you can use any other parameter as well.
```ruby
client.availabilities.list_user_busy_times(user: `user_uri`, start_time: `start_time`, end_time: `end_time`)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserBusyTime type="calendly", start_time="2020-01-02T20:00:00.000000Z", end_time="2020-01-02T20:30:00.000000Z", buffered_start_time="2020-01-02T19:30:00.000000Z", buffered_end_time="2020-01-02T21:00:00.000000Z", event=#<OpenStruct uri="https://api.calendly.com/scheduled_events/abc123">, client=#<Calendlyr::Client>, uuid=nil>, #<Calendlyr::UserBusyTime type="calendly", start_time="2020-01-05T20:00:00.000000Z", end_time="2020-01-05T20:30:00.000000Z", buffered_start_time="2020-01-05T19:30:00.000000Z", buffered_end_time="2020-01-05T21:00:00.000000Z", event=#<OpenStruct uri="https://api.calendly.com/scheduled_events/abc12345">, client=#<Calendlyr::Client>, uuid=nil>, #<Calendlyr::UserBusyTime type="external", start_time="2020-01-07T20:00:00.000000Z", end_time="2020-01-07T20:30:00.000000Z", client=#<Calendlyr::Client>, uuid=nil>], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Event

```ruby
user_busy_time.associated_event
#=> #<Calendlyr::Event>
```
