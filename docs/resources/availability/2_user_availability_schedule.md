# User Availability Schedule

## Retrieve

This will return the availability schedule of the given UUID.See [official API doc](https://developer.calendly.com/api-docs/3b1c2d5f97b5c-get-user-availability-schedule)

```ruby
client.user_availability_schedules.retrieve(uuid: @uuid)
#=> #<Calendlyr::UserAvailabilitySchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">
```

## List

Return the availability schedules of the given user. See [official API doc](https://developer.calendly.com/api-docs/8098de44af94c-list-user-availability-schedules)

```ruby
client.user_availability_schedules.list(user_uri: @user_uri)
#=> #<Calendlyr::Collection:0x0000000105b6e0d0 @data=[#<Calendlyr::UserAvailabilitySchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">, #<Calendlyr::UserAvailabilitySchedule uri="https://api.calendly.com/user_availability_schedule/abc456", default=false, name="Evening Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="monday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="tuesday">, #<OpenStruct type="wday", intervals=[], wday="wednesday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="thursday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="friday">, #<OpenStruct type="wday", intervals=[], wday="saturday">, #<OpenStruct type="date", intervals=[#<OpenStruct from="08:30", to="09:30">], date="2028-12-31">], client=#<Calendlyr::Client>, uuid="abc456">], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### List on me

Use `me` user

```ruby
client.me.availability_schedules
#=> #<Calendlyr::Collection:0x0000000105b6e0d0 @data=[#<Calendlyr::UserAvailabilitySchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">, #<Calendlyr::UserAvailabilitySchedule uri="https://api.calendly.com/user_availability_schedule/abc456", default=false, name="Evening Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="monday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="tuesday">, #<OpenStruct type="wday", intervals=[], wday="wednesday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="thursday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="friday">, #<OpenStruct type="wday", intervals=[], wday="saturday">, #<OpenStruct type="date", intervals=[#<OpenStruct from="08:30", to="09:30">], date="2028-12-31">], client=#<Calendlyr::Client>, uuid="abc456">], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Next

See [Data Compliance](/docs/resources/2_data_compliance.md)
