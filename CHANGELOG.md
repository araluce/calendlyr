# Changelog

All notable changes to this project will be documented in this file.

## [0.10.0]

### Added
* `Calendlyr.configure`, `Calendlyr.configuration`, `Calendlyr.client`, and `Calendlyr.reset!` — module-level global configuration and default client support with token/timeout settings
* Optional request/response logging via `Client.new(logger:)` or `Calendlyr.configure { |c| c.logger = ... }` — INFO for method/URL/status/duration, DEBUG for response body (truncated), WARN for retries, ERROR for API errors. Authorization header is never logged.
* `Object#to_json` — Serialize any API object to JSON. Works with `JSON.generate`, nested objects, and arrays. The internal `client` reference is automatically excluded from serialization.
* `client.data_compliance.delete_scheduled_event_data` — Remove scheduled events data within a time range (`POST /data_compliance/deletion/events`)
* `put_request` support in `Resource` base class for PUT HTTP verb
* `Collection` now includes `Enumerable` — use `each`, `map`, `select` directly on collections
* Configurable HTTP timeouts via `Client.new(token:, open_timeout:, read_timeout:)` (default 30s)
* Automatic retry with exponential backoff for 429 Too Many Requests (max 3 retries, respects `Retry-After` header)

### Changed — Breaking
* **`Calendlyr::Object`** no longer inherits from `OpenStruct`. Replaced with a zero-dependency hash-backed class. Dynamic dot-access for all API fields is preserved. If you were relying on `OpenStruct`-specific methods (e.g., `marshal_dump`), this is a breaking change.
* Empty API responses (e.g., DELETE) now return `{}` instead of `true`
* Requires Ruby >= 3.2.0 (dropped support for Ruby 2.4–3.1)

### Fixed
* Error messages now include request context (`GET /path`) and expose structured attributes on `Calendlyr::Error` (`status`, `http_method`, `path`, `response_body`) for easier debugging
* **Security:** Removed `OpenSSL::SSL::VERIFY_NONE` — SSL connections now properly verify certificates
* **Security:** Bare `rescue` replaced with `rescue JSON::ParserError` — non-JSON errors are no longer silently swallowed
* `Invitee#cancel` now correctly uses the event UUID instead of the invitee UUID
* `CGI.parse` replaced with `URI.decode_www_form` for Ruby 4.0 compatibility
* Tautological test assertions (`assert` with string literal) replaced with `assert_equal`

### Removed
* `codecov` gem dependency (deprecated since Feb 2022, incompatible with Ruby 4.0). Coverage uploads now use `codecov-action` in CI.

[0.10.0]: https://github.com/araluce/calendlyr/compare/v0.9.0...v0.10.0

## [0.9.0]

### Added
* `client.event_types.create` — Create standard event types (`POST /event_types`)
* `client.event_types.update` — Update existing event types (`PATCH /event_types/:uuid`)
* `client.event_types.list_availability_schedules` — List availability schedules for an event type (`GET /event_type_availability_schedules`)
* `client.event_types.update_availability_schedule` — Update availability schedules (`PATCH /event_type_availability_schedules`)
* `client.locations.list` — List host's connected locations: Zoom, Google Meet, etc. (`GET /locations`)
* `client.events.create_invitee` — Programmatically book events via the Scheduling API (`POST /invitees`)
* `patch_request` support in `Resource` base class for PATCH HTTP verb

### Changed
* Updated `Event` fixtures with `buffered_start_time`, `buffered_end_time`, `meeting_notes_plain`, `meeting_notes_html`, and `cancellation` fields
* Updated `Invitee` fixtures with `no_show`, `reconfirmation`, `scheduling_method`, and `invitee_scheduled_by` fields

### Removed — Breaking
* **`client.outgoing_communications`** — `OutgoingCommunicationsResource` removed (endpoint no longer in Calendly API docs)
* **`client.scheduling_links`** — `SchedulingLinksResource` and `SchedulingLink` object removed (endpoint no longer in Calendly API docs)
* **`client.webhooks.sample_webhook_data`** — Method removed (endpoint no longer in Calendly API docs)
* **`client.event_types.list_available_times`** — Method and `EventTypes::AvailableTime` object removed (endpoint no longer in Calendly API docs)
* **`client.event_types.list_memberships`** — Method and `EventTypes::Membership` object removed (endpoint no longer in Calendly API docs)
* **`EventType#available_times`** — Convenience method removed (delegates to removed `list_available_times`)
* **`Share#associated_scheduling_links`** — Method removed (depends on removed `SchedulingLink`)
* **`Organization#sample_webhook_data`** — Convenience method removed (delegates to removed `webhooks.sample_webhook_data`)

[0.9.0]: https://github.com/araluce/calendlyr/compare/v0.8.0...v0.9.0

## [0.8.0]
* **Breaking:** All error classes (`BadRequest`, `NotFound`, `Unauthenticated`, `PermissionDenied`, `ExternalCalendarError`, `TooManyRequests`, `InternalServerError`) now inherit from `Calendlyr::Error` instead of `StandardError`. Code using `rescue Calendlyr::Error` will now catch all API errors.
* Fix: Response handling with empty body
* Fix: Some doc typos

[0.8.0]: https://github.com/araluce/calendlyr/compare/v0.7.5...v0.8.0

## [0.7.5]
* Fix: Calendlyr::TooManyRequests was not included in autoloading list
* Fix: Calendlyr::ExternalCalendarError typo in class name

[0.7.5]: https://github.com/araluce/calendlyr/compare/v0.7.4...v0.7.5

## [0.7.4]
* Fix: Error class name typo `ExternalCalendarEror` -> `ExternalCalendarError`
* Fix: Error class name typo `TooManyRequestsEror` -> `TooManyRequests`
* Updating rubies versions in CI to add 3.3
* Adding total rubygems downloads badge to README

[0.7.4]: https://github.com/araluce/calendlyr/compare/v0.7.3...v0.7.4

## [0.7.3]
* Fix: Prevent possible empty body response to fail

[0.7.3]: https://github.com/araluce/calendlyr/compare/v0.7.1...v0.7.3

## [0.7.1]
* Adding support for 429 responses from Calendly API

[0.7.1]: https://github.com/araluce/calendlyr/compare/v0.7.0...v0.7.1

## [0.7.0]
* First real usable release :tada:

[0.7.0]: https://github.com/araluce/calendlyr/compare/v0.1.0...v0.7.0
