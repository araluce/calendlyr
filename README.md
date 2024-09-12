[![](https://img.shields.io/github/license/araluce/calendlyr)](https://github.com/araluce/calendlyr/blob/master/LICENSE.txt)
[![](https://github.com/araluce/calendlyr/actions/workflows/ci.yml/badge.svg)](https://github.com/araluce/calendlyr/actions)
[![codecov](https://codecov.io/gh/araluce/calendlyr/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendlyr)
[![Gem Version](https://badge.fury.io/rb/calendlyr.svg)](https://badge.fury.io/rb/calendlyr)

# Calendly API Rubygem

Easy and complete rubygem for [Calendly](https://calendly.com/). Currently supports [API v2](https://calendly.stoplight.io/docs/api-docs).

Just needed a Personal Access Token.

## Dependencies

No dependencies :tada:

We know about the importance of not add dependencies that you don't want.

## 📚 Docs

* [Installation](docs/1_installation.md)
* [Usage](docs/2_usage.md)
* **Resources**
  * [Pagination](/docs/resources/1_pagination.md)
  * **Availabilities**
    * [Availabilities::Rule](/docs/resources/availabilities/1_rule.md)
    * [Availabilities::UserSchedule](/docs/resources/availabilities/2_user_busy_time.md)
    * [Availabilities::UserSchedule](/docs/resources/availabilities/3_user_availability_schedule.md)
  * [Data Compliance](/docs/resources/2_data_compliance.md)
  * [User](/docs/resources/user.md)

### Event Types
````ruby
client.event_types.list user_uri: "user_uri", organization_uri: "organization_uri"
client.event_types.retrieve event_type_uuid: "id"
````

### Events
````ruby
client.events.list user: "user_uri", organization: "organization_uri", group: "group_uri"
client.events.retrieve event: "event_uuid"
````

### Event Invitees
````ruby
client.events.list_invitees uuid: "event_uuid"
client.events.retrieve_invitee event_uuid: "event_uuid", invitee_uuid: "invitee_uuid"
````

### Scheduling Links
````ruby
client.scheduling_links.create owner: "owner_uri", max_event_count: 1, owner_type: "EventType"
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
client.organization.webhooks(scope: "scope")
client.organization.create_webhook(url: "post_callback_url", events: ["invitee.canceled", "invitee.created"], scope: "scope")

# List activity log
client.organization.activity_log
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
