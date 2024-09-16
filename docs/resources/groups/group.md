# Group Calendlyr::Group

The Group resource that was requested. Represents groupings of Users within an Organization.

Visit official [API Doc](https://developer.calendly.com/api-docs/15c7951a86b40-group)

## Client requests

### Retrieve

Returns information about a specified Group.

Visit official [API Doc](https://developer.calendly.com/api-docs/beaf147a3bc34-get-group)

```ruby
client.groups.retrieve(uuid: uuid)
#=> #<Calendlyr::Group>
```

### List

Returns a list of groups.

Visit official [API Doc](https://developer.calendly.com/api-docs/6rb6dtdln74sy-list-groups)

```ruby
client.groups.list(organization: organization_uri)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Group>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
group.associated_organization
#=> #<Calendlyr::Organization>
```

### Events

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
group.events
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Event>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Group Relationships

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
group.group_relationships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Groups::Relationship>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
