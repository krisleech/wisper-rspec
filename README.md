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

### Using message expections

If you need to assert on the arguments broadcast you can subscribe a double 
with a [message expection](https://github.com/rspec/rspec-mocks#message-expectations)
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
