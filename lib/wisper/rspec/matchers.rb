require 'rspec/expectations'

module Wisper
  module RSpec
    class EventRecorder
      attr_reader :broadcast_events

      def initialize
        @broadcast_events = []
      end

      def respond_to?(method_name)
        true
      end

      def method_missing(method_name, *args, &block)
        @broadcast_events << [method_name.to_s, *args]
      end

      def broadcast?(event_name, *args)
        if args.size > 0
          @broadcast_events.include?([event_name.to_s, *args])
        else
          @broadcast_events.map(&:first).include?(event_name.to_s)
        end
      end
    end

    module BroadcastMatcher
      class Matcher
        def initialize(event, *args)
          @event = event
          @args = args
        end

        def supports_block_expectations?
          true
        end

        def matches?(block)
          @event_recorder = EventRecorder.new

          Wisper.subscribe(@event_recorder) do
            block.call
          end

          @event_recorder.broadcast?(@event, *@args)
        end

        def failure_message
          msg = "expected publisher to broadcast #{@event} event"
          if @args.size == 0
            if @event_recorder.broadcast_events.any?
              msg += " (not included in #{@event_recorder.broadcast_events.map(&:first).join(', ')})"
            else
              msg += " (no events broadcast)"
            end
          end
          msg += " with args: #{@args.inspect}" if @args.size > 0
          msg
        end

        def failure_message_when_negated
          msg = "expected publisher not to broadcast #{@event} event"
          msg += " with args: #{@args.inspect}" if @args.size > 0
          msg
        end
      end

      def broadcast(event, *args)
        Matcher.new(event, *args)
      end
    end
  end

  # Prior to being extracted from Wisper the matcher was namespaced as Rspec,
  # it is now RSpec. This will raise a helpful message for those upgrading to
  # Wisper 2.0
  module Rspec
    module BroadcastMatcher
      def self.included(base)
        raise 'Please include Wisper::RSpec::BroadcastMatcher instead of Wisper::Rspec::BroadcastMatcher (notice the capitalization of RSpec)'
      end
    end
  end
end
