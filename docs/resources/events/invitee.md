# Invitee Calendlyr::Events::Invitee

An individual who has been invited to meet with a Calendly member.

Visit official [API Doc](https://developer.calendly.com/api-docs/decca36cf717f-invitee)

## Client requests

### Retrieve

Returns information about a specified Invitee (person invited to an event).

Visit official [API Doc](https://developer.calendly.com/api-docs/8305c0ccfac70-get-event-invitee)

```ruby
client.events.retrieve_invitee(event_uuid: event_uuid, invitee_uuid: invitee_uuid)
#=> #<Calendlyr::Events::Invitee>
```
### List

Returns a list of Invitees for an event.

Visit official [API Doc](https://developer.calendly.com/api-docs/eb8ee72701f99-list-event-invitees)

```ruby
client.events.list_invitees(uuid: uuid)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Events::Invitee>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
