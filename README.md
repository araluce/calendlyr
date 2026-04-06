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

<<<<<<< feat/to-json
### JSON Serialization

All API objects support `#to_json` for easy serialization (caching, logging, API proxying):

```ruby
event = client.events.retrieve(uuid: "ABC123")

event.to_json
#=> '{"uri":"https://api.calendly.com/scheduled_events/ABC123","name":"30 Minute Meeting",...}'

# Works with JSON.generate and nested objects
JSON.generate(event)

# Round-trip: parse back into an Object
parsed = Calendlyr::Object.new(JSON.parse(event.to_json))
parsed.name  #=> "30 Minute Meeting"
```

> **Note:** `#to_json` and `#to_h` exclude the internal `client` reference — only API data is serialized.
=======
### Error Context

API errors now include the HTTP method and path in the message, and expose structured attributes for debugging:

```ruby
begin
  client.events.retrieve(uuid: "INVALID_UUID")
rescue Calendlyr::NotFound => error
  error.message       #=> "[Error 404] GET /scheduled_events/INVALID_UUID — Not Found. The resource you requested does not exist."
  error.status        #=> 404
  error.http_method   #=> "GET"
  error.path          #=> "/scheduled_events/INVALID_UUID"
  error.response_body #=> { "title" => "Not Found", "message" => "..." }
end
```

This makes debugging failed requests much easier without changing existing `rescue Calendlyr::Error` patterns.
>>>>>>> master

## Documentation

For the full list of available resources and methods, check out the [API Reference](docs/resources/).

## Contributing

1. Fork it ( https://github.com/araluce/calendlyr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, please write tests and update the [docs](docs/resources/).
