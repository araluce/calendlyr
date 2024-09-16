# Routing Form Calendlyr::RoutingForm

Information about a routing form.

Visit official [API Doc](https://developer.calendly.com/api-docs/20e016678903c-routing-form)

## Client requests

### Retrieve

Get a specified Routing Form.

Visit official [API Doc](https://developer.calendly.com/api-docs/910a7e2f573e8-get-routing-form)

```ruby
client.routing_forms.retrieve(uuid: form_uuid)
#=> #<Calendlyr::RoutingForm>
```

### List

Get a list of Routing Forms for a specified Organization.

Visit official [API Doc](https://developer.calendly.com/api-docs/9fe7334bec6ad-list-routing-forms)

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
client.routing_forms.list(organization: organization_uri)
#=> #<Calendlyr::Collection @data=[#<Calendlyr::RoutingForm>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Organization

```ruby
routing_form.associated_organization
#=> #<Calendlyr::Organization>
```

### Submissions
For the example bellow we will use not parameters, but you can use the allowed parameters in Calendly docs.

```ruby
routing_form.submissions
#=> #<Calendlyr::Collection @data=[#<Calendlyr::RoutingForms::Submission>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```
