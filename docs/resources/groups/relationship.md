# Group Relationship Calendlyr::Groups::Relationship

A group relationship record for an individual. A given individual may have more than one admin relationship to multiple groups, but only one member relationship to a single group.

Visit official [API Doc](https://developer.calendly.com/api-docs/a82d8ee79eb82-group-relationship)

## Client requests

### Retrieve

Returns a group relationship by uuid.

Visit official [API Doc](https://developer.calendly.com/api-docs/91925872af92a-get-group-relationship)

```ruby
client.groups.retrieve_relationship(uuid: uuid)
#=> #<Calendlyr::Groups::Relationship>
```

### List

Returns a list of group relationships - a given owner can have one membership record, but multiple admin records.

Visit official [API Doc](https://developer.calendly.com/api-docs/4674a12f55f82-list-group-relationships)

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
client.groups.list_relationships
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Groups::Relationship>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
group_relationship.associated_organization
#=> #<Calendlyr::Organization>
```

### Associated Group

```ruby
group_relationship.associated_group
#=> #<Calendlyr::Group>
```

### Associated Owner

```ruby
group_relationship.associated_owner
#=> #<Calendlyr::Organizations::Membership>
```
