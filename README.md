[![](https://img.shields.io/github/license/araluce/calendlyr)](https://github.com/araluce/calendlyr/blob/master/LICENSE.txt)
[![](https://github.com/araluce/calendlyr/actions/workflows/ci.yml/badge.svg)](https://github.com/araluce/calendlyr/actions)
[![codecov](https://codecov.io/gh/araluce/calendlyr/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendlyr)
[![Gem Version](https://badge.fury.io/rb/calendlyr.svg)](https://badge.fury.io/rb/calendlyr)

# Calendly API Rubygem LITE version

Easy and complete rubygem for [Calendly](https://calendly.com/). Currently supports [API v2](https://calendly.stoplight.io/docs/api-docs).

Just needed a Personal Access Token.

> If you need a Oauth authentication maybe you need [calendly-api-ruby-client](https://github.com/koshilife/calendly-api-ruby-client)

## Dependencies

No dependencies :tada:

We know about the importance of not add dependencies that you don't want.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'calendlyr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calendlyr

## Usage

To access the API, you'll need to create a `Calendlyr::Client` and pass in your token. You can generate your Personal Access Token at [https://calendly.com/integrations/api_webhooks](https://calendly.com/integrations/api_webhooks)

```ruby
client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"])
```

The client then gives you access to each of the resources.

## Resources

The gem maps as closely as we can to the Calendly API so you can easily convert API examples to gem code.

Responses are created as objects like `Calendlyr::Event`. Having types like `Calendlyr::User` is handy for understanding what type of object you're working with. They're built using OpenStruct so you can easily access data in a Ruby-ish way.

##### Pagination

`collection` endpoints return pages of results. The result object will have a `data` key to access the results, as well as pagination like `next_page` for retrieving the next pages. You may also specify the

```ruby
results = client.me.events(count: 5)
#=> Calendlyr::Collection

results.count
#=> 5

results.data
#=> [#<Calendlyr::Event>, #<Calendlyr::Event>]

results.next_page_token
#=> "KfKBetd7bS0wsFINjYky9mp8ZJXv76aL"

# Retrieve the next page
client.me.events(count: 5, next_page_token: results.next_page_token)
#=> Calendlyr::Collection
```

### Users
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

#### Me (Cached)

Probably you need to make many calls through `client.me`, so we decided to not make calls for every `client.me` reference by caching it the first time. However, if you need to reload the content of `me` you can `force_relaod` to force a new call.

```ruby
client.me # makes a call and caches the response
client.me # no call, value cached
client.me(force_reload: true) # makes a new call and update cache value
```


### Event Types
````ruby
client.event_types.list user_uri: "user_uri", organization_uri: "organization_uri"
client.event_types.retrieve event_type_uuid: "id"
````

### Events
````ruby
client.events.list user_uri: "user_uri", organization_uri: "organization_uri"
client.events.retrieve event_uuid: "event_uuid"
````

### Event Invitees
````ruby
client.event_invitees.list event_uuid: "event_uuid"
client.event_invitees.retrieve event_uuid: "event_uuid", invitee_uuid: "invitee_uuid"
````

### Scheduling Links
````ruby
client.scheduling_links.create owner_uri: "owner_uri", max_event_count: 1, owner_type: "EventType"
````

### Organizations
````ruby
# Create invitation
client.organizations.invite(organization_uuid: "organization_uuid", email: "test@test.com")
client.organization.invite(email: "test@test.com")
# List invitations
client.organizations.list_invitations(organization_uuid: "organization_uuid")
client.organization.list_invitations
# Get invitation
client.organizations.retrieve_invitation(organization_uuid: "organization_uuid", invitation_uuid: "invitation_uuid")
client.organization.invitation(invitation_uuid: "invitation_uuid")
# Revoke invitation
client.organizations.revoke_invitation(organization_uuid: "organization_uuid", invitation_uuid: "organization_uuid")
client.organization.revoke_invitation(invitation_uuid: "organization_uuid")
invitation = client.organization.invitation(invitation_uuid: "invitation_uuid")
invitation.revoke

# List memberships
client.organizations.list_memberships
client.organization.memberships
# Get membership
client.organizations.retrieve_membership(membership_uuid: "membership_uuid")
# Remove membership
client.organizations.remove_user(membership_uuid: "membership_uuid")

client.organization.events

# List/Creaete webhooks
client.organization.list_webhooks(scope: "scope")
client.organization.create_webhook(url: "post_callback_url", events: ["invitee.canceled", "invitee.created"], scope: "scope")
````

### Webhooks
```ruby
client.webhooks.list(organization_uri: "organization_uri", scope: "scope")
client.webhooks.create(url: "post_callback_url", events: ["invitee.canceled", "invitee.created"], organization_uri: "organization_uri", scope: "scope")
client.webhooks.retrieve(webhook_uuid: "webhook_uuid")
client.webhooks.delete(webhook_uuid: "webhook_uuid")
```

### Data Compliance
```ruby
client.data_compliance.delete_invitee_data
```

## Contributing

1. Fork it ( https://github.com/araluce/calendlyr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, add to the list of resources in lib/calendlyr. Additionally, write a spec and add it to the list in the README.

## Thanks

Many thanks [@markets](https://github.com/markets) (our contributor in the shadows) for all comments, details and tips for this rubygem project and for made me grow professionally in my day by day :raised_hands:

Thanks [@excid3](https://github.com/excid3) and his [Vultr.rb](https://github.com/excid3/vultr.rb) rubygem project.