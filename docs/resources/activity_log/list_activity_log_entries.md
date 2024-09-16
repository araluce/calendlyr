# List Activity Log Entries  Calendlyr::ActivityLog

This endpoint requires an Enterprise subscription.

## Client requests

### List

Returns a list of activity log entries

Visit official [API Doc](https://developer.calendly.com/api-docs/d37c7f031f339-list-activity-log-entries)

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
client.organizations.activity_log(organization: `organization_uri`)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::ActivityLog, ...], @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
user_busy_time.associated_organization
#=> #<Calendlyr::Organization>
```

### Associated Actor

```ruby
user_busy_time.associated_actor
#=> #<Calendlyr::User>
```
