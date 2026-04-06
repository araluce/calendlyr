# Changelog

All notable changes to this project will be documented in this file.

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
