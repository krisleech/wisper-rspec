# Wisper::Rspec

Rspec matcher and stubbing for [Wisper](https://github.com/krisleech/wisper).

[![Gem Version](https://badge.fury.io/rb/wisper-rspec.png)](http://badge.fury.io/rb/wisper-rspec)
[![Build Status](https://travis-ci.org/krisleech/wisper-rspec.png?branch=master)](https://travis-ci.org/krisleech/wisper-rspec)

## Installation

```ruby
gem 'wisper-rspec', require: false
```

## Usage

### Broadcast Matcher

In `spec_helper`

```ruby
require 'wisper/rspec/matchers'

RSpec::configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
end
```

In your specs:
```ruby
expect { publisher.execute }.to broadcast(:an_event)
```
This will match both `broadcast(:an_event)` and `broadcast(:an_event, :arg_1)`.


```ruby
# with optional arguments
expect { publisher.execute }.to broadcast(:another_event, :arg_1, :arg_2)
```

With event arguments, it matches only if the event is broadcast with those arguments. This assertion matches `broadcast(:another_event, :arg_1, :arg_2)` but not `broadcast(:another_event)`.

```ruby
# with arguments matcher
expect { publisher.execute }.to broadcast(:event, hash_including(a: 2))
```

Rspec values matcher can be used to match arguments. This assertion matches `broadcast(:another_event, a: 2, b: 1)` but not `broadcast(:another_event, a: 3)`

Matchers can be composed using [compound rspec matchers](http://www.rubydoc.info/gems/rspec-expectations/RSpec/Matchers/Composable):

```ruby
expect {
  publisher.execute(123)
  publisher.execute(234)
}.to broadcast(:event, 123).and broadcast(:event, 234)

expect {
  publisher.execute(123)
  publisher.execute(234)
}.to broadcast(:event, 123).or broadcast(:event, 234)
```

Note that the `broadcast` method is aliased as `publish`, similar to the *Wisper* library itself.

### Not broadcast matcher

If you want to assert a broadcast was not made you can use `not_broadcast` which is especially useful when chaining expectations.

```ruby
expect {
  publisher.execute(123)
}.to not_broadcast(:event, 99).and broadcast(:event, 123)
```

### Using message expectations

If you need to assert on the listener receiving broadcast arguments you can subscribe a double
with a [message expectation](https://github.com/rspec/rspec-mocks#message-expectations)
and then use any of the [argument matchers](https://github.com/rspec/rspec-mocks#argument-matchers).

```ruby
listener = double('Listener')

expect(listener).to receive(:an_event).with(some_args)

publisher.subscribe(listener)

publisher.execute
```

### Stubbing publishers

You can stub publishers and their events in unit (isolated) tests that only care about reacting to events.

Given this piece of code:

```ruby
class MyController
  def create
    publisher = MyPublisher.new

    publisher.on(:some_event) do |variable|
      return "Hello with #{variable}!"
    end

    publisher.execute
  end
end
```

You can test it like this:

```ruby
require 'wisper/rspec/stub_wisper_publisher'

describe MyController do
  context "on some_event" do
    before do
      stub_wisper_publisher("MyPublisher", :execute, :some_event, "foo")
    end

    it "renders" do
      response = MyController.new.create
      expect(response).to eq "Hello with foo!"
    end
  end
end
```

This is useful when testing Rails controllers in isolation from the business logic.

You can use any number of args to pass to the event:

```ruby
stub_wisper_publisher("MyPublisher", :execute, :some_event, "foo1", "foo2", ...)
```

See `spec/lib/rspec_extensions_spec.rb` for a runnable example.


## Contributing

Yes, please.
