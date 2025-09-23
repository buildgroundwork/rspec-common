# Rspec::Common

🧐 Common additions and enhancements for Rails testing with RSpec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-common'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec-common

## Usage

In your rails_helper.rb file:

```ruby
  # To include all enhancements
  require "rspec/common/all"
```

or

```ruby
  # To pick and choose which enhancements you would like:
  require "rspec/common/shared_examples/controllers"
  require "rspec/common/matchers/views/json"
```

NB: Requiring `rspec/common/all` does *NOT* include fixes for specific Rails
versions.

```ruby
  # To include fixes specific to Rails 7
  require "rspec/common/all"
  require "rspec/common/rails7_fixes"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buildgroundwork/rspec-common.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

