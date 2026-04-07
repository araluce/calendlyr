[![](https://img.shields.io/github/license/araluce/calendlyr)](https://github.com/araluce/calendlyr/blob/master/LICENSE.txt)
[![](https://github.com/araluce/calendlyr/actions/workflows/ci.yml/badge.svg)](https://github.com/araluce/calendlyr/actions)
[![codecov](https://codecov.io/gh/araluce/calendlyr/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendlyr)
![Gem Downloads](https://img.shields.io/gem/dt/calendlyr)

# Calendlyr

![Calendlyr logo](logos/calendlyr_bg_white.png)

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

## Global configuration

For single-tenant apps, you can configure `Calendlyr` once and reuse a default client:

```ruby
Calendlyr.configure do |config|
  config.token = ENV.fetch("CALENDLY_TOKEN")
  config.open_timeout = 5
  config.read_timeout = 15
end

client = Calendlyr.client
events = client.events.list(user: "YOUR_USER_UUID")
```

`Calendlyr.client` memoizes a client instance and rebuilds it if token or timeout values change.

### Optional request/response logging

Calendlyr can emit request lifecycle logs with any logger object that responds to `info`, `debug`, `warn`, and `error` (for example Ruby's stdlib `Logger`). Logging is opt-in.

```ruby
require "logger"

client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"], logger: Logger.new($stdout))
```

Or configure it globally:

```ruby
Calendlyr.configure do |config|
  config.token = ENV.fetch("CALENDLY_TOKEN")
  config.logger = Logger.new($stdout)
end
```

In Rails, this is typically configured in an initializer:

```ruby
# config/initializers/calendlyr.rb
Calendlyr.configure do |config|
  config.token = ENV.fetch("CALENDLY_TOKEN")
end
```

> [!IMPORTANT]
> `Calendlyr.client` is module-global and **not thread-safe for multi-tenant usage**.
> If your app serves multiple tenants or uses per-request credentials, use `Calendlyr::Client.new(token:)` per request.

### Bare UUIDs

Every method that takes a Calendly resource reference (like `user:`, `organization:`, `event_type:`) accepts both bare UUIDs and full URIs. The gem expands bare UUIDs automatically:

```ruby
# Both are equivalent:
client.events.list(user: "YOUR_USER_UUID")
client.events.list(user: "https://api.calendly.com/users/YOUR_USER_UUID")
```

The gem mirrors the Calendly API closely, so converting API examples into gem code is straightforward. Responses are wrapped in Ruby objects with dot-access for every field.

## Documentation

For the full list of available resources and methods, check out the [API Reference](docs/resources/).

## Contributing

1. Fork it ( https://github.com/araluce/calendlyr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, please write tests and update the [docs](docs/resources/).
