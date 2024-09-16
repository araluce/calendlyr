# Organization Invitation Calendlyr::Organizations::Invitation

Organization Invitation object.

Visit official [API Doc](https://developer.calendly.com/api-docs/736b3f42c9586-organization-invitation)

## Client requests

### Retrieve

Returns an Organization Invitation that was sent to the organization's members.

Visit official [API Doc](https://developer.calendly.com/api-docs/f3f0b6c2a95c7-get-organization-invitation)

```ruby
client.organizations.retrieve_invitation(org_uuid: organization_uuid, uuid: invitation_uuid)
#=> #<Calendlyr::Organizations::Invitation>
```

### Invite

Invites a user to an organization.

Visit official [API Doc](https://developer.calendly.com/api-docs/094d15d2cd4ab-invite-user-to-organization)

```ruby
client.organizations.invite(organization_uuid: organization_uuid, email: "email@example.com")
#=> #<Calendlyr::Organizations::Invitation>
```

### List

Returns a list of Organization Invitations that were sent to the organization's members.

Visit official [API Doc](https://developer.calendly.com/api-docs/3ad68ee2cc606-list-organization-invitations)

For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
client.organizations.list_invitations(uuid: organization_uuid)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Organizations::Invitation>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
organization_invitation.associated_organization
#=> #<Calendlyr::Organization>
```

### Associated User

```ruby
organization_invitation.associated_user
#=> #<Calendlyr::User>
```

### Revoke

```ruby
organization_invitation.revoke
#=>
```
