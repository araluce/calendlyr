# User

```ruby
client.me
client.users.me
client.retrieve(user_uuid: "uuid")

client.organization
#=> #<Calendlyr::Organization>

client.me.event_types
#=> Calendlyr::Collection @data=[#<Calendlyr::EventType>, #<Calendlyr::EventType>]

client.me.events
#=> Calendlyr::Collection @data=[#<Calendlyr::Event>, #<Calendlyr::Event>]

client.me.memberships
#=> Calendlyr::Collection @data=[#<Calendlyr::MemberShip>, #<Calendlyr::MemberShip>]
```

## Me (Cached)

Probably you need to make many calls through `client.me`, so we decided to not make calls for every `client.me` reference by caching it the first time. However, if you need to reload the content of `me` you can `force_relaod` to force a new call.

```ruby
client.me # makes a call and caches the response
client.me # no call, value cached
client.me(force_reload: true) # makes a new call and update cache value
```

## Next

