# Available Time Calendlyr::EventTypes::AvailableTime

An available meeting time slot for the given event type.

Visit official [API Doc](https://developer.calendly.com/api-docs/2d8d322931358-event-type-available-time)

## Client requests

### List
Returns a list of available times for an event type within a specified date range.

Date range can be no greater than 1 week (7 days).

For the examples bellow we will use only required parameters, but you can use any other parameter as well.

Visit official [API Doc](https://developer.calendly.com/api-docs/6a1be82aef359-list-event-type-available-times)

```ruby
client.event_types.list_available_times(event_type, event_type, start_time: start_time, end_time: end_time)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::AvailableTime>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
