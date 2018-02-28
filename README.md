# RailsIncludesEngine

A small gem to parse a string syntax to includes hash. Allows includeing associated ressources for APIs in a graphql-like manner.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_includes_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_includes_engine

You can access the main class by calling:
```ruby
require "install rails_includes_engine"

RailsIncludesEngine::IncludesEngine.new
```
## Usage

Just initialize the class of this gem with the string you'd like to parse:
```ruby
includes_engine = RailsIncludesEngine::IncludesEngine.new params[:includes]

# Do this to optimize performance
posts.includes includes_engine.includes_hash simple: true

render json: posts, includes: includes_engine.includes_hash
```

## Syntax
The string `user{avatar,friends},comments` can get parsed to include the following associated ressources:
- User
  - Avatar
  - Friends
- Comments

TODO: Add more examples and further description
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yanniz0r/rails_includes_engine. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

