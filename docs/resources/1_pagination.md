# Pagination

`collection` endpoints return pages of results. The result object will have a `data` key to access the results, as well as pagination like `next_page` for retrieving the next pages. You may also specify the

```ruby
results = client.me.events(count: 5)
#=> Calendlyr::Collection

results.count
#=> 5

results.data
#=> [#<Calendlyr::Event>, #<Calendlyr::Event>]

results.next_page_token
#=> "KfKBetd7bS0wsFINjYky9mp8ZJXv76aL"

# Retrieve the next page
client.me.events(count: 5, next_page_token: results.next_page_token)
#=> Calendlyr::Collection
```

## Next

See [User](resources/2_user.md)
