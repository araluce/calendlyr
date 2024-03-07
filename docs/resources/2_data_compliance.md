# Data Compliance

## Delete Invitee Data

Remove invitee data from all previously booked events in your organization. Take a look on [official API doc](https://developer.calendly.com/api-docs/4cf896120a018-delete-invitee-data) for more information.

```ruby
client.data_compliance.delete_invitee_data(emails: %w[test@email.org test2@email.org])
```

## Delete Scheduled Event Data

Remove scheduled events data within a time range for your organization. Take a look on [official API doc](https://developer.calendly.com/api-docs/fc9211ad9b551-delete-scheduled-event-data) for more information.

```ruby
client.data_compliance.delete_scheduled_event_data(start_time: "2019-01-02T03:04:05.678123Z", end_time: "2021-01-01T02:04:05.678123Z")
```
