[![](https://img.shields.io/github/license/araluce/calendlyr)](https://github.com/araluce/calendlyr/blob/master/LICENSE.txt)
[![](https://github.com/araluce/calendlyr/actions/workflows/ci.yml/badge.svg)](https://github.com/araluce/calendlyr/actions)
[![codecov](https://codecov.io/gh/araluce/calendlyr/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendlyr)
![Gem Downloads](https://img.shields.io/gem/dt/calendlyr)

# Calendlyr

The simplest way to interact with [Calendly's API v2](https://developer.calendly.com/api-docs) in Ruby. No dependencies, no complexity — just a Personal Access Token and you're good to go.

## Installation

Add to your Gemfile:

```ruby
gem "calendlyr"
```

Then run `bundle install`. That's it.

## Quick Start

```ruby
client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"])

# List your scheduled events — just pass the UUID, no full URI needed
events = client.events.list(user: "YOUR_USER_UUID")
events.data
#=> [#<Calendlyr::Event>, #<Calendlyr::Event>, ...]

# Access event details naturally
event = events.data.first
event.name       #=> "30 Minute Meeting"
event.status      #=> "active"
event.start_time  #=> "2024-01-15T10:00:00.000000Z"

# List invitees for an event
invitees = client.events.list_invitees(uuid: event.uuid)
invitees.data.first.email  #=> "john@example.com"
```

### Bare UUIDs

Every method that takes a Calendly resource reference (like `user:`, `organization:`, `event_type:`) accepts both bare UUIDs and full URIs. The gem expands bare UUIDs automatically:

```ruby
# Both are equivalent:
client.events.list(user: "YOUR_USER_UUID")
client.events.list(user: "https://api.calendly.com/users/YOUR_USER_UUID")
```

The gem mirrors the Calendly API closely, so converting API examples into gem code is straightforward. Responses are wrapped in Ruby objects with dot-access for every field.

### Webhook signature verification

`Calendlyr::Webhook` (singular) verifies signed webhook payloads. This is separate from `client.webhooks` / `Calendlyr::Webhooks` (plural), which are API resources for managing webhook subscriptions.

```ruby
payload = request.body.read
header = request.get_header("HTTP_CALENDLY_WEBHOOK_SIGNATURE")

if Calendlyr::Webhook.valid?(payload: payload, header: header, signing_key: ENV.fetch("CALENDLY_WEBHOOK_SIGNING_KEY"))
  webhook = Calendlyr::Webhook.parse(
    payload: payload,
    header: header,
    signing_key: ENV.fetch("CALENDLY_WEBHOOK_SIGNING_KEY")
  )

  webhook.event   #=> "invitee.created"
  webhook.payload #=> Calendlyr::Webhooks::InviteePayload (for invitee events)
end
```

## Documentation

For the full list of available resources and methods, check out the [API Reference](docs/resources/).

## Contributing

1. Fork it ( https://github.com/araluce/calendlyr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, please write tests and update the [docs](docs/resources/).
