[![](https://img.shields.io/github/license/araluce/calendlyr)](https://github.com/araluce/calendlyr/blob/master/LICENSE.txt)
[![](https://github.com/araluce/calendlyr/actions/workflows/ci.yml/badge.svg)](https://github.com/araluce/calendlyr/actions)
[![codecov](https://codecov.io/gh/araluce/calendlyr/branch/master/graph/badge.svg?token=YSUU4PHM6Y)](https://codecov.io/gh/araluce/calendlyr)
[![Gem Version](https://badge.fury.io/rb/calendlyr.svg)](https://badge.fury.io/rb/calendlyr)

# Calendly API Rubygem

Easy and complete rubygem for [Calendly](https://calendly.com/). Currently supports [API v2](https://calendly.stoplight.io/docs/api-docs).

Just needed a Personal Access Token.

## Dependencies

No dependencies :tada:

We know about the importance of not add dependencies that you don't want.

## 📚 Docs

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'calendlyr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calendlyr

### Usage

To access the API, you'll need to create a `Calendlyr::Client` and pass in your token. You can generate your Personal Access Token at [https://calendly.com/integrations/api_webhooks](https://calendly.com/integrations/api_webhooks)

```ruby
client = Calendlyr::Client.new(token: ENV["CALENDLY_TOKEN"])
```

The client then gives you access to each of the resources.


### Resources

The gem maps as closely as we can to the Calendly API so you can easily convert API examples to gem code.

Responses are created as objects like `Calendlyr::Event`. Having types like `Calendlyr::User` is handy for understanding what type of object you're working with. They're built using OpenStruct so you can easily access data in a Ruby-ish way.

* [Pagination](docs/resources/pagination.md)
* **Activity Log**
    * [Calendlyr::ActivityLog](docs/resources/activity_log/list_activity_log_entries.md)
* **Availabilities**
    * [Calendlyr::Availabilities::Rule](docs/resources/availabilities/availability_rule.md)
    * [Calendlyr::Availabilities::UserSchedule](docs/resources/availabilities/user_availability_schedule.md)
    * [Calendlyr::Availabilities::UserBusyTime](docs/resources/availabilities/user_busy_time.md)
* [Data Compliance](docs/resources/data_compliance.md)
* **Event Types**
    * [Calendlyr::EventType](docs/resources/event_types/event_type.md)
    * [Calendlyr::EventTypes::AvailableTime](docs/resources/event_types/available_time.md)
    * [Calendlyr::EventTypes::Membership](docs/resources/event_types/membership.md)
    * [Calendlyr::EventTypes::Profile](docs/resources/event_types/profile.md)
* **Groups**
    * [Calendlyr::Group](docs/resources/groups/group.md)
    * [Calendlyr::Groups::Relationship](docs/resources/groups/relationship.md)
* **Organizations**
    * [Calendlyr::Organization](docs/resources/organizations/organization.md)
    * [Calendlyr::Organizations::Invitation](docs/resources/organizations/invitation.md)
    * [Calendlyr::Organizations::Membership](docs/resources/organizations/membership.md)
* **Routing Forms**
    * [Calendlyr::RoutingForm](docs/resources/routing_forms/routing_form.md)
    * [Calendlyr::RoutingForms::Submission](docs/resources/routing_forms/submission.md)
* **Schedule Events**
    * [Calendlyr::Event](docs/resources/events/event.md)
    * [Calendlyr::Events::Cancellation](docs/resources/events/cancellation.md)
    * [Calendlyr::Events::Guest](docs/resources/events/guest.md)
    * [Calendlyr::Events::Invitee](docs/resources/events/invitee.md)
    * [Calendlyr::Events::InviteeNoShow](docs/resources/events/invitee_no_show.md)
* [Scheduled Links](docs/resources/scheduling_link.md)
* [Shares](docs/resources/share.md)
* [Users](docs/resources/user.md)
* **Webhooks**
    * [Calendlyr::Webhooks::Subscription](docs/resources/webhooks/subscription.md)
    * [Calendlyr::Webhooks::Payload](docs/resources/webhooks/payload.md)
    * [Calendlyr::Webhooks::InviteePayload](docs/resources/webhooks/invitee_payload.md)

## Contributing

1. Fork it ( https://github.com/araluce/calendlyr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding resources, add to the list of resources in lib/calendlyr. Additionally, write a spec and add it to the list in the README.

## Thanks

Many thanks [@markets](https://github.com/markets) (our contributor in the shadows) for all comments, details and tips for this rubygem project and for made me grow professionally in my day by day :raised_hands:

Thanks [@excid3](https://github.com/excid3) and his [Vultr.rb](https://github.com/excid3/vultr.rb) rubygem project.
