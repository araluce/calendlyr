# Organization Calendlyr::Organization

Organization object.

Visit official [API Doc](https://developer.calendly.com/api-docs/848e5e20591ee-organization)

## Me

We can access your organization information by calling `organization` method on the client object.

```ruby
organization = client.organization
#=> #<Calendlyr::Organization>
```

## Object methods

### Activity Logs

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.activity_logs
#=> #<Calendlyr::Collection @data=[#<Calendlyr::ActivityLog>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Events

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.events
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Event Types

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.event_types
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Routing Forms

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.routing_forms
#=> #<Calendlyr::Collection @data=[#<Calendlyr::RoutingForm>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Groups

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.groups
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Group>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Group Relationships

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.group_relationships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Groups::Relationship>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Memberships

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.memberships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Membership>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Membership

```ruby
organization.membership(uuid: uuid)
#=> #<Organizations::Membership>
```

### Webhooks

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.webhooks(scope: scope)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Webhooks::Subscription>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Create a Webhook

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.create_webhook(url:, url, events: events, scope: scope)
#=> #<Calendlyr::Webhooks::Subscription>
```

### Sample Webhook Data

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.sample_webhook_data(event: event, scope: scope)
#=> #<Calendlyr::Object>
```

### Invite user

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.invite_user(email: 'email@example.com')
#=> #<Calendlyr::Organizations::Invitation>
```

### Invitations

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization.invitations
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Invitation>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Invitation

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.invitation(invitation_uuid: invitation_uuid)
#=> #<Calendlyr::Organizations::Invitation>
```

### Revoke an invitation

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
organization.revoke_invitation(invitation_uuid: invitation_uuid)
#=>
```
