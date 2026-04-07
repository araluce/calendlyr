# Outgoing Communication (`Calendlyr::OutgoingCommunication`)

Outgoing communication object.

Visit official [API Doc](https://developer.calendly.com/api-docs)

## Client requests

### List

Returns outgoing communications for a specified Organization.

Visit official [API Doc](https://developer.calendly.com/api-docs)

```ruby
# organization: accepts a bare UUID or full Calendly URI
client.outgoing_communications.list(organization: "ORG_UUID")
#=> #<Calendlyr::Collection @data=[#<Calendlyr::OutgoingCommunication>, ...], ...>
```

### List All

Fetches every page and returns a flat Array.

```ruby
client.outgoing_communications.list_all(organization: "ORG_UUID")
#=> [#<Calendlyr::OutgoingCommunication>, ...]
```
