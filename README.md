# ActiveRecordMap

A small gem for simplifying access to json columns via activerecord and map.

Wrap PostgreSQL json ActiveRecord attributes with Map, which provides ordered and indifferent hash access (e.g. `ar_record.json_attr['foo'][:bar]`) as well as access via instance methods (e.g. `ar_record.json_attr.foo.bar`).

## Dependencies

See gem deps in the Gemfile.

Obviously there is also a dependency on PostgreSQL >= 9.2. See the PostgreSQL docs for more: http://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.2#JSON_datatype.

Big thank you to Ara T. Howard for the `Map`!

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_map'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_map

## Usage

See the tests.

### Gotcha

The tests are all stored alongside their components, i.e. there is no separate `test/` or `spec/` directory. This structure is inspired by `ng-boilerplate` (thanks Josh D. Miller). I thought I'd give it a try in ruby-land (would be surprised if I'm the first one to try it), feedback welcome.

## Todo

Would be useful to have this wrap hstore columns as well.

In fact, would be nice if Map just replaced HashWithIndifferentAccess altogether. Ramifications?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
