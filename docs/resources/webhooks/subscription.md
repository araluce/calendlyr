# Webhook Subscription Calendlyr::Wehooks::Subscription

Webhook Subscription Object.

Visit official [API Doc](https://developer.calendly.com/api-docs/9950e4dff7351-webhook-subscription)

## Client requests

### Create

Create a Webhook Subscription for an Organization or User.

Visit official [API Doc](https://developer.calendly.com/api-docs/c1ddc06ce1f1b-create-webhook-subscription)

```ruby
client.webhooks.create(url: 'https://example.com/webhook', events: ['invitee.created'], organization: organization_uri, scope: 'organization')
#=> #<Calendlyr::Webhooks::Subscription>

client.webhooks.create(url: 'https://example.com/webhook', events: ['invitee.created'], organization: organization_uri, user: user_uri, scope: 'user')
#=> #<Calendlyr::Webhooks::Subscription>

client.webhooks.create(url: 'https://example.com/webhook', events: ['invitee.created'], organization: organization_uri, group: group_uri, scope: 'group')
#=> #<Calendlyr::Webhooks::Subscription>
```

### Retrieve

Get a specified Webhook Subscription.

Visit official [API Doc](https://developer.calendly.com/api-docs/4d800dc2cb119-get-webhook-subscription)

```ruby
client.webhooks.retrieve(webhook_uuid: webhook_uuid)
#=> #<Calendlyr::Webhooks::Subscription>
```

### List

Get a list of Webhook Subscriptions for a specified Organization or User.

Visit official [API Doc](https://developer.calendly.com/api-docs/faac832d7c57d-list-webhook-subscriptions)

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
client.webhooks.list(organization: organization_uri, scope: 'organization')
#=> #<Calendlyr::Collection @data=[#<Calendlyr::Webhooks::Subscription>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

### Delete

Delete a Webhook Subscription.

Visit official [API Doc](https://developer.calendly.com/api-docs/565b97f62dafe-delete-webhook-subscription)

```ruby
client.webhooks.delete(webhook_uuid: webhook_uuid)
#=>
```

## Object methods

### Associated Organization

```ruby
webhook_subscription.associated_organization
#=> #<Calendlyr::Organization>
```

### Associated User

```ruby
webhook_subscription.associated_user
#=> #<Calendlyr::User>
```

### Associated Creator

```ruby
webhook_subscription.associated_creator
#=> #<Calendlyr::User>
```

### active?

```ruby
webhook_subscription.active?
#=> true
```

### disabled?

```ruby
webhook_subscription.disabled?
#=> false
```
