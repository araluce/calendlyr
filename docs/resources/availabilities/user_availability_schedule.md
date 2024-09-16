# User Availability Schedule Calendlyr::Availabilities::UserSchedule

The availability schedule set by the user.

Visit official [API Doc](https://developer.calendly.com/api-docs/008bd39518269-user-availability-schedule)

## Client requests

### Retrieve

This will return the availability schedule of the given UUID.See [official API doc](https://developer.calendly.com/api-docs/3b1c2d5f97b5c-get-user-availability-schedule)

```ruby
client.availabilities.retrieve_user_schedule(uuid: @uuid)
#=> #<Calendlyr::Availabilities::UserSchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">
```

### List

Return the availability schedules of the given user. See [official API doc](https://developer.calendly.com/api-docs/8098de44af94c-list-user-availability-schedules)

```ruby
client.availabilities.list_user_schedules(user: @user)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserSchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">, #<Calendlyr::Availabilities::UserSchedule uri="https://api.calendly.com/user_availability_schedule/abc456", default=false, name="Evening Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="monday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="tuesday">, #<OpenStruct type="wday", intervals=[], wday="wednesday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="thursday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="friday">, #<OpenStruct type="wday", intervals=[], wday="saturday">, #<OpenStruct type="date", intervals=[#<OpenStruct from="08:30", to="09:30">], date="2028-12-31">], client=#<Calendlyr::Client>, uuid="abc456">], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

#### List on me

Use `me` user

```ruby
client.me.availability_schedules
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Availabilities::UserSchedule uri="https://api.calendly.com/user_availability_schedule/abc123", default=true, name="Working Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="09:30">], wday="sunday", date="2022-12-31">], client=#<Calendlyr::Client>, uuid="abc123">, #<Calendlyr::Availabilities::UserSchedule uri="https://api.calendly.com/user_availability_schedule/abc456", default=false, name="Evening Hours", user="https://api.calendly.com/users/abc123", timezone="America/New_York", rules=[#<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="monday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="tuesday">, #<OpenStruct type="wday", intervals=[], wday="wednesday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="thursday">, #<OpenStruct type="wday", intervals=[#<OpenStruct from="08:30", to="17:00">], wday="friday">, #<OpenStruct type="wday", intervals=[], wday="saturday">, #<OpenStruct type="date", intervals=[#<OpenStruct from="08:30", to="09:30">], date="2028-12-31">], client=#<Calendlyr::Client>, uuid="abc456">], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated User

```ruby
user_schedule.associated_user
#=> #<Calendlyr::User>
```

### Associated Rules

```ruby
user_schedule.rules
#=> [#<Calendlyr::Availabilities::Rule>, ...]
```
