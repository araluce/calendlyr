# Organization Membership Calendlyr::Organizations::Membership

Organization Membership object.

Visit official [API Doc](https://developer.calendly.com/api-docs/ae30b41b52a54-organization-membership)

## Client requests

### Retrieve

Returns information about a user's Organization Membership.

Visit official [API Doc](https://developer.calendly.com/api-docs/8c3baa79a5883-get-organization-membership)

```ruby
client.organizations.retrieve_membership(uuid: uuid)
#=> #<Calendlyr::Organizations::Membership>
```

### List

Use this to list the Organization Memberships for all users belonging to an organization.

Visit official [API Doc](https://developer.calendly.com/api-docs/eaed2e61a6bc3-list-organization-memberships)

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
client.organizations.list_memberships(user: user)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Membership>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>

client.organizations.list_memberships(organization: organization)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Membership>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
organization_membership.associated_organization
#=> #<Calendlyr::Organization>
```

### Associated User

```ruby
organization_membership.associated_user
#=> #<Calendlyr::User>
```

### Group Relationships
For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
organization_membership.group_relationships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Groups::Relationship>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
