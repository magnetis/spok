# Spok

By [Magnetis](https://magnetis.com.br)

[![Build Status](https://travis-ci.org/magnetis/spok.svg?branch=master)](https://travis-ci.org/magnetis/spok)

Spok is a tool for dealing with workdays and restdays in an easy way.
It also provides functionalities for working with periods of dates.

## Installation

Add this line to your application's Gemfile:

    gem 'spok'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spok

## Usage

### Dealing with workdays

You can use the `Spok::Workday` module to check if a date is either a restday or a workday:

```ruby
require 'spok'

Spok::Workday.workday?(Date.new(2012, 12, 24))
# => true
```

Spok also supports different calendars for checking if a date is a workday or a
restday

```ruby
require 'spok'

Spok::Workday.workday?(Date.new(2012, 12, 24), calendar: :bovespa)
# => false
```

If `calendar` is not informed, it will default to the `:brasil` calendar.

The available calendars are defined with `.yml` files [here](lib/spok/config/).

### Working with periods of dates

Objects from the `Spok` class can be used to work with periods of dates. You can
initialize a new object passing the start and end date for your period to the
`new` method:

```ruby
require 'spok'

period = Spok.new(Date.new(2018, 9, 14), Date.new(2018, 10, 14))
another_period = Spok.new(Date.today, Date.today + 10.days)
```

You can also use the `Spok.parse` method to initialize a new object using a string:

```ruby
require 'spok'

parsed_period = Spok.parse('20180901-20180903')
```

With the object, you can check for all the workdays in that period of dates:

```ruby
require 'spok'

period = Spok.new(Date.new(2018, 10, 10), Date.new(2018, 10, 14))
period.workdays
# => [Wed, 10 Oct 2018, Thu, 11 Oct 2018]
```

### Set default calendar
```ruby
Spok.default_calendar = :bovespa
```

## Documentation

The complete documentation in the RDoc format is available here:

https://www.rubydoc.info/gems/spok

## Contributing

Please read our [Contributing](CONTRIBUTING.md) guide for more information.

## License

This project is licensed under the terms of the Apache 2. Copyright 2014-2018 Magnetis http://www.magnetis.com.br
See the [LICENSE](LICENSE.txt) file for license rights and limitations (Apache 2).
