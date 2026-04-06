# Routing Form Submission Calendlyr::RoutingForms::Submission

Information about a Routing Form Submission.

Visit official [API Doc](https://developer.calendly.com/api-docs/09b54c4d45b62-routing-form-submission)

## Client requests

### Retrieve

Get a specified Routing Form Submission.

Visit official [API Doc](https://developer.calendly.com/api-docs/f4ccebf48e5b5-get-routing-form-submission)

```ruby
client.routing_forms.retrieve_submission(uuid: submission_uuid)
#=> #<Calendlyr::RoutingForms::Submission>
```

### List

Get a list of Routing Form Submissions for a specified Routing Form.

Visit official [API Doc](https://developer.calendly.com/api-docs/17db5cb915a57-list-routing-form-submissions)

For the example bellow we will use only required parameters, but you can use any other parameter as well.

```ruby
# form: accepts a bare UUID or full Calendly URI
client.routing_forms.list_submissions(form: "ROUTING_FORM_UUID")
#=> #<Calendlyr::Collection @data=[#<Calendlyr::RoutingForms::Submission>, ...], @count=nil, @next_page=nil, @next_page_token=nil, @client=#<Calendlyr::Client>>
```

## Object methods

### Associated Routing Form

```ruby
routing_form_submission.associated_routing_form
#=> #<Calendlyr::RoutingForm>
```
