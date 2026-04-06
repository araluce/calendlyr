# Availability Schedule Calendlyr::EventTypes::AvailabilitySchedule

Availability schedule object for event types.

## Client requests

### List

Returns a list of availability schedules for an event type.

```ruby
client.event_types.list_availability_schedules(event_type_uuid: event_type_uuid)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventTypes::AvailabilitySchedule>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Update

Updates availability schedules for an event type.

```ruby
client.event_types.update_availability_schedule(
  event_type_uuid: event_type_uuid,
  availability_schedules: [
    {start_time: "2023-10-27T09:00:00Z", end_time: "2023-10-27T12:00:00Z"}
  ]
)
#=> {"message"=>"Availability schedules updated successfully."}
```
