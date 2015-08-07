require 'wisper'
require_relative '../../../../lib/wisper/rspec/matchers'

describe Wisper::RSpec::BroadcastMatcher::Matcher do
  let(:event_name) { 'it_happened' }
  let(:matcher)    { described_class.new(event_name) }

  let(:broadcaster) do
    Class.new do
      include Wisper.publisher

      public :broadcast
    end.new
  end

  context 'matching event broadcast' do
    let(:block) do
      Proc.new do
        broadcaster.broadcast(event_name)
      end
    end

    describe '#matches?' do
      it 'returns true' do
        expect(matcher.matches?(block)).to be_truthy
      end
    end
  end

  context 'no events broadcast' do
    let(:block) { Proc.new {} }

    describe '#matches?' do
      it 'returns false' do
        expect(matcher.matches?(block)).to be_falsey
      end
    end

    describe '#failure_message' do
      before { matcher.matches?(block) }

      it 'has descriptive failure message' do
        expect(matcher.failure_message).to eq "expected publisher to broadcast #{event_name} event (no events broadcast)"
      end
    end
  end

  context 'non-matching event broadcast' do
    let(:block) do
      Proc.new do
        broadcaster.broadcast('event1')
        broadcaster.send(:broadcast, 'event2', 12345, :foo)
      end
    end

    describe '#matches?' do
      it 'returns false' do
        expect(matcher.matches?(block)).to be_falsey
      end
    end

    describe '#failure_message' do
      before { matcher.matches?(block) }

      it 'has descriptive failure message' do
        message = "expected publisher to broadcast it_happened event "\
          "(actual events broadcast: event1, event2(12345, foo))"
        expect(matcher.failure_message).to eq(message)
      end
    end
  end
end
