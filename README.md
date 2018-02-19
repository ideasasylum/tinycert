# Tinycert

A small client for the Tinycert.org api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinycert'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinycert

## Usage

```ruby
require 'tinycert'
tinycert = TinyCert.new '<your@email.address>', '<your passphrase>', '<your api key>'
```

Note, your API key can be found [in the API documentation](https://www.tinycert.org/docs/api/v1/intro)

**Your passphrase is _not_ the same as your password**. You should have your passphrase stored in your browser or securely elsewhere. You can set your password on the [Tinycert profile page](https://www.tinycert.org/profile)

### List all CAs

```ruby
cas = tinycert.authorities.list
```

### Fetch a CA

```ruby
ca = tinycert.authorities[1111]
=> #<Tinycert::CertAuthority:0x007f83423cd710 @id=1111, @name="Ideas Asylum">
```

### Create a cert

```ruby
ca.certs.create 'example.com', names: ['example.com', 'www.example.com', '*.example.com']
```

### Find all the valid certs

```ruby
certs = ca.certs.good
[#<Tinycert::Cert:0x007f97d84043c8 @id=11111, @status="good", @cn=nil, @names=[]>]
```

### Get more details

```
certs.first.details
=> #<Tinycert::Cert:0x007ff34bb0fce8 @id=14236, @status="good", @cn="lvh.me", @names=["lvh.me", "*.lvh.me"]>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ideasasylum/tinycert.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
