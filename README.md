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

Calendlyr can emit request lifecycle logs with any logger-like object that responds to `info`, `debug`, `warn`, and `error`. Logging is opt-in, and the gem does not ship a logger implementation for you.

```ruby
require "logger"

client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"], logger: Logger.new($stdout))
```

`Logger` is just an example. You can pass any object that responds to `info`, `debug`, `warn`, and `error`.

If you're on Ruby 4 and want to use Ruby's `Logger`, make sure your application includes the `logger` gem.

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

## Auto-pagination

Calendlyr supports lazy auto-pagination for all collection endpoints. There are two ways to consume paginated results:

### `list_all` — Eager, returns a flat Array

The simplest option. Fetches every page and returns all items as an Array.

```ruby
# Get all events across all pages (e.g., hundreds of events)
events = client.events.list_all(organization: "YOUR_ORG_UUID")
events  #=> [#<Calendlyr::Event>, #<Calendlyr::Event>, ...]

# Same pattern works for every resource with a list method:
client.event_types.list_all(organization: "YOUR_ORG_UUID")
client.webhooks.list_all(organization: "YOUR_ORG_UUID", scope: "organization")
client.organizations.list_all_memberships(organization: "YOUR_ORG_UUID")
client.organizations.list_all_invitations(uuid: "YOUR_ORG_UUID")
client.organizations.list_all_activity_log(organization: "YOUR_ORG_UUID")
client.groups.list_all(organization: "YOUR_ORG_UUID")
client.groups.list_all_relationships(organization: "YOUR_ORG_UUID")
client.routing_forms.list_all(organization: "YOUR_ORG_UUID")
client.routing_forms.list_all_submissions(form: "YOUR_FORM_UUID")
client.availability.list_all_user_busy_times(user: "YOUR_USER_UUID", start_time: "...", end_time: "...")
client.availability.list_all_user_schedules(user: "YOUR_USER_UUID")
client.locations.list_all
```

### `auto_paginate` — Lazy Enumerator

Returns an `Enumerator::Lazy` that fetches pages on demand. Pages are only requested as you consume items, so you can stop early without fetching all pages.

```ruby
collection = client.events.list(organization: "YOUR_ORG_UUID")

# Take only the first 50 events — fetches only as many pages as needed
first_50 = collection.auto_paginate.take(50)

# Filter lazily — stops fetching once the condition is met
active = collection.auto_paginate.select { |e| e.status == "active" }.first(10)

# Consume all items lazily
collection.auto_paginate.each do |event|
  puts event.name
end
```

### Breaking change in v0.11.0

The `#next_page` attr_reader that previously returned the raw next-page URL string has been renamed to `#next_page_url`. The `#next_page` method now returns the **next Collection** (or `nil` if there are no more pages).

```ruby
# Before (v0.10.x):
collection.next_page  #=> "https://api.calendly.com/...?page_token=..."

# After (v0.11.0):
collection.next_page_url  #=> "https://api.calendly.com/...?page_token=..."
collection.next_page      #=> #<Calendlyr::Collection> or nil
```

## Documentation

For the full list of available resources and methods, check out the [API Reference](docs/resources/).

## Contributing

1. [Fork it](https://github.com/araluce/calendlyr/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, please write tests and update the [docs](docs/resources/).
