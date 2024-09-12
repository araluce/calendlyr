# User

```ruby
client.me
client.users.me
client.users.retrieve(uuid: "uuid")
#=> #<Calendlyr::User avatar_url=nil, created_at="2021-01-20T15:46:27.251298Z", current_organization="https://api.calendly.com/organizations/123abc", email="test@email.org", name="John Doe", resource_type="User", scheduling_url="https://calendly.com/john-doe", slug="john-doe", timezone="Europe/Berlin", updated_at="2024-01-21T11:39:27.889254Z", uri="https://api.calendly.com/users/123abc", client=#<Calendlyr::Client>, uuid="123abc">

client.organization
#=> #<Calendlyr::Organization uri="https://api.calendly.com/organizations/123abc", client=#<Calendlyr::Client>, uuid="123abc">

client.me.event_types
#=> #<Calendlyr::Collection @data=[#<Calendlyr::EventType active=true, admin_managed=false, booking_method="instant", color="#f8e436", created_at="2021-12-02T07:43:57.994910Z", custom_questions=[#<OpenStruct answer_choices=[], enabled=true, include_other=false, name="Please share anything that will help prepare for our meeting.", position=0, required=false, type="text">], deleted_at=nil, description_html=nil, description_plain=nil, duration=15, internal_note=nil, kind="solo", locations=[#<OpenStruct kind="zoom_conference">], name="15 Minute Meeting", pooling_type=nil, position=0, profile=#<OpenStruct name="John Doe", owner="https://api.calendly.com/users/abc123", type="User">, scheduling_url="https://calendly.com/john-doe/15min", secret=false, slug="15min", type="StandardEventType", updated_at="2022-01-10T17:24:53.767416Z", uri="https://api.calendly.com/event_types/abc123", client=#<Calendlyr::Client>, uuid="abc123">]>

client.me.events
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event calendar_event=#<OpenStruct external_id="abc123", kind="google">, created_at="2022-05-27T11:49:29.726091Z", end_time="2022-05-27T17:30:00.000000Z", event_guests=[], event_memberships=[#<OpenStruct user="https://api.calendly.com/users/abc123", user_email="test@email.org", user_name="John Doe">], event_type="https://api.calendly.com/event_types/abc123", invitees_counter=#<OpenStruct active=1, limit=1, total=1>, location=#<OpenStruct data=#<OpenStruct>, join_url=nil, status=nil, type="zoom">, meeting_notes_html=nil, meeting_notes_plain=nil, name="30 Minute Meeting", start_time="2022-05-27T17:00:00.000000Z", status="active", updated_at="2022-05-27T11:49:31.007529Z", uri="https://api.calendly.com/scheduled_events/abc123", client=#<Calendlyr::Client>, uuid="abc123">]>

client.me.memberships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Membership created_at="2021-12-02T07:43:56.752548Z", organization="https://api.calendly.com/organizations/abc123", role="owner", updated_at="2022-01-10T14:52:50.966271Z", uri="https://api.calendly.com/organization_memberships/abc123", user=#<OpenStruct avatar_url=nil, created_at="2021-01-20T15:46:27.251298Z", email="test@email.org", name="John Doe", timezone="Europe/Berlin", updated_at="2024-01-21T11:39:27.889254Z", uri="https://api.calendly.com/users/abc123", scheduling_url="https://calendly.com/john-doe", slug="john-doe">, client=#<Calendlyr::Client>, uuid="abc123">]>
```

## Me

Probably you need to make many calls through `client.me`, so we decided to not make calls for every `client.me` reference by memoizing it the first time.

```ruby
client.me # makes a call and memoize the response
client.me # no call, value memoized
```

### Force reload

However, if you need to reload the content of `me` you can `force_relaod` to force a new call.

```ruby
client.me(force_reload: true) # makes a new call and update memoized value
```


## Next
