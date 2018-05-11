require_relative '../../../lib/wisper/rspec/matchers'

RSpec::configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
end

describe 'not_broadcast matcher' do
  let(:publisher_class) { Class.new { include Wisper::Publisher } }
  let(:publisher)       { publisher_class.new }

  it 'can be chained with broadcast' do
    expect { publisher.send(:broadcast, :foobar) }.to not_broadcast(:barfoo).and broadcast(:foobar)
  end
end

describe 'broadcast matcher' do
  let(:publisher_class) { Class.new { include Wisper::Publisher } }
  let(:publisher)       { publisher_class.new }

  it 'passes when publisher broadcasts inside block' do
    expect { publisher.send(:broadcast, :foobar) }.to broadcast(:foobar)
  end

  context 'with arguments' do
    it 'passes when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to broadcast(:fizzbuzz, 12345)
    end

    it 'passes without arguments when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to broadcast(:fizzbuzz)
    end

    it 'passes with rspect arguments matchers' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to broadcast(:fizzbuzz, kind_of(Numeric))
    end

    it 'fails with rspec arguments matchers' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to_not broadcast(:fizzbuzz, kind_of(Hash))
    end

    it 'fails with incorrect arguments when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.not_to broadcast(:fizzbuzz, 98765)
    end
  end

  context 'with compound assertions' do
    it 'passes when both values are expected' do
      expect {
        publisher.send(:broadcast, :fizzbuzz, 12345)
        publisher.send(:broadcast, :fizzbuzz, 54321)
      }.to broadcast(:fizzbuzz, 12345).and broadcast(:fizzbuzz, 54321)
    end

    it 'passes when either value is expected' do
      expect {
        publisher.send(:broadcast, :fizzbuzz, 54321)
      }.to broadcast(:fizzbuzz, 12345).or broadcast(:fizzbuzz, 54321)
    end
  end

  it 'passes with not_to when publisher does not broadcast inside block' do
    expect { publisher }.not_to broadcast(:foobar)
  end
end
