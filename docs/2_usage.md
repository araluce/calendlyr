# Usage

To access the API, you'll need to create a `Calendlyr::Client` and pass in your token. You can generate your Personal Access Token at [https://calendly.com/integrations/api_webhooks](https://calendly.com/integrations/api_webhooks)

```ruby
client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"])
```

The client then gives you access to each of the resources.

## Next

See [Resources](3_resources.md)
