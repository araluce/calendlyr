# Sample Webhook Data

Fetch sample webhook payload data for a given event, organization, and scope.

Visit official [API Doc](https://developer.calendly.com/api-docs)

## Client requests

### Sample

Returns raw sample webhook data. The response shape varies by event type, so this method returns the raw response hash instead of a typed object.

Visit official [API Doc](https://developer.calendly.com/api-docs)

```ruby
# organization: accepts a bare UUID or full Calendly URI
client.webhooks.sample(
  event: "invitee.created",
  organization: "ORG_UUID",
  scope: "organization"
)
#=> { "payload" => { ... } }
```
