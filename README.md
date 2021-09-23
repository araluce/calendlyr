[![](https://img.shields.io/github/license/araluce/calendly.rb)](https://github.com/araluce/calendly.rb/blob/master/LICENSE.txt)
![](https://github.com/araluce/calendly.rb/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/araluce/calendly.rb/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendly.rb)
[![GitHub version](https://badge.fury.io/gh/araluce%2Fcalendly.rb.svg)](https://badge.fury.io/gh/araluce%2Fcalendly.rb)

# Calendly API Rubygem

Easy and complete rubygem for [Calendly](https://calendly.com/). Currently supports [API v2](https://calendly.stoplight.io/docs/api-docs).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'calendlyr', github: "araluce/calendly.rb"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calendlyr

## Usage

To access the API, you'll need to create a `Calendly::Client` and pass in your API key. You can generate your Personal Access Token at [https://calendly.com/integrations/api_webhooks](https://calendly.com/integrations/api_webhooks)

```ruby
client = Calendly::Client.new(api_key: ENV["CALENDLY_API_KEY"])
```

The client then gives you access to each of the resources.

## Resources

The gem maps as closely as we can to the Calendly API so you can easily convert API examples to gem code.

Responses are created as objects like `Calendly::Event`. Having types like `Calendly::User` is handy for understanding what type of object you're working with. They're built using OpenStruct so you can easily access data in a Ruby-ish way.

##### Pagination

`collection` endpoints return pages of results. The result object will have a `data` key to access the results, as well as pagination like `next_page` for retrieving the next pages. You may also specify the

```ruby
results = client.me.events(count: 5)
#=> Calendly::Collection

results.count
#=> 5

results.data
#=> [#<Calendly::Event>, #<Calendly::Event>]

results.next_page_token
#=> "KfKBetd7bS0wsFINjYky9mp8ZJXv76aL"

# Retrieve the next page
client.me.events(count: 5, next_page_token: results.next_page_token)
#=> Calendly::Collection
```

### Users
```ruby
client.me
client.users.me
client.retrieve(user_uuid: "uuid")

client.organization
#=> #<Calendly::Organization>

client.me.event_types
#=> Calendly::Collection @data=[#<Calendly::EventType>, #<Calendly::EventType>]

client.me.events
#=> Calendly::Collection @data=[#<Calendly::Event>, #<Calendly::Event>]

client.me.memberships
#=> Calendly::Collection @data=[#<Calendly::MemberShip>, #<Calendly::MemberShip>]
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
#Revoke invitation
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
````

### Webhooks
```ruby
client.webhooks.list(organization_uri: "organization_uri", scope: "scope")
client.webhooks.create(resource_uri: "resource_uri", events: ["invitee.canceled", "invitee.created"], organization_uri: "organization_uri", scope: "scope")
client.webhooks.retrieve(webhook_uuid: "webhook_uuid")
client.webhooks.delete(webhook_uuid: "webhook_uuid")
```

### Data Compliance
```ruby
client.data_compliance.delete_invitee_data
```

## Contributing

1. Fork it ( https://github.com/araluce/calendly.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, add to the list of resources in lib/calendly.rb. Additionally, write a spec and add it to the list in the README.

## Thanks

Thanks [@excid3](https://github.com/excid3) and his [Vultr.rb](https://github.com/excid3/vultr.rb) rubygem project.