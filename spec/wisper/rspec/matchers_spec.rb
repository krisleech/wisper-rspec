require_relative '../../../lib/wisper/rspec/matchers'

RSpec::configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
end

describe 'broadcast matcher' do
  let(:publisher_class) { Class.new { include Wisper::Publisher } }
  let(:publisher)       { publisher_class.new }

  it 'passes when publisher broadcasts inside block' do
    expect { publisher.send(:broadcast, :foobar) }.to broadcast(:foobar)
  end

  context "with arguments" do
    it 'passes when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to broadcast(:fizzbuzz, 12345)
    end

    it 'passes without arguments when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.to broadcast(:fizzbuzz)
    end

    it 'fails with incorrect arguments when publisher broadcasts inside block' do
      expect { publisher.send(:broadcast, :fizzbuzz, 12345) }.not_to broadcast(:fizzbuzz, 98765)
    end
  end

  it 'passes with not_to when publisher does not broadcast inside block' do
    expect { publisher }.not_to broadcast(:foobar)
  end
end
