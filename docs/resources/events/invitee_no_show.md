# Invitee No Show Calendlyr::Events::InviteeNoShow

Information about an invitees no show.

Visit official [API Doc](https://developer.calendly.com/api-docs/753a78b938d75-invitee-no-show)

## Client requests

### Retrieve

Returns information about a specified Invitee No Show.

Visit official [API Doc](https://developer.calendly.com/api-docs/49cf0c87ee6f4-get-invitee-no-show)

```ruby
client.events.retrieve_invitee_no_show(uuid: uuid)
#=> #<Calendlyr::Events::InviteeNoShow>
```

### Create

Marks an Invitee as a No Show.

Visit official [API Doc](https://developer.calendly.com/api-docs/cebd8c3170790-create-invitee-no-show)

```ruby
client.events.create_invitee_no_show(invitee: invitee_uri)
#=> #<Calendlyr::Events::InviteeNoShow>
```

### Delete

Undoes marking an Invitee as a No Show.

Visit official [API Doc](https://developer.calendly.com/api-docs/eb599c64c95ea-delete-invitee-no-show)

```ruby
client.events.delete_invitee_no_show(uuid: uuid)
#=>
```

## Object methods

### Delete

```ruby
invitee_no_show.delete
#=>
```
