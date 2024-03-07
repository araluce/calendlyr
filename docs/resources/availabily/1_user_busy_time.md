# User Busy Time

User internal and external scheduled events within a specified date range.

Date range can be no greater than 1 week (7 days).

## List

Visit official [API Doc](https://developer.calendly.com/api-docs/5920076156501-list-user-busy-times) to see [query parameters](https://developer.calendly.com/api-docs/5920076156501-list-user-busy-times) and [response body](https://developer.calendly.com/api-docs/5920076156501-list-user-busy-times#response-body)

```ruby
user_busy_times = client.user_busy_times.list(user_uri: `user_uri`, start_time: `start_time`, end_time: `end_time`)
#=> #<Calendlyr::Collection:0x0000000108f30698 @data=[#<Calendlyr::UserBusyTime type="calendly", start_time="2020-01-02T20:00:00.000000Z", end_time="2020-01-02T20:30:00.000000Z", buffered_start_time="2020-01-02T19:30:00.000000Z", buffered_end_time="2020-01-02T21:00:00.000000Z", event=#<OpenStruct uri="https://api.calendly.com/scheduled_events/abc123">, client=#<Calendlyr::Client>, uuid=nil>, #<Calendlyr::UserBusyTime type="calendly", start_time="2020-01-05T20:00:00.000000Z", end_time="2020-01-05T20:30:00.000000Z", buffered_start_time="2020-01-05T19:30:00.000000Z", buffered_end_time="2020-01-05T21:00:00.000000Z", event=#<OpenStruct uri="https://api.calendly.com/scheduled_events/abc12345">, client=#<Calendlyr::Client>, uuid=nil>, #<Calendlyr::UserBusyTime type="external", start_time="2020-01-07T20:00:00.000000Z", end_time="2020-01-07T20:30:00.000000Z", client=#<Calendlyr::Client>, uuid=nil>], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
