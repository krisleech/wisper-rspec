require_relative '../../../../lib/wisper/rspec/matchers'

describe Wisper::RSpec::EventRecorder do
  describe '#method' do
    describe 'given :id' do
      it 'does not raise an error' do
        expect { Wisper::RSpec::EventRecorder.new.method(:id) }.not_to raise_error
      end
    end
  end

  describe '#respond_to?' do
    it 'returns true' do
      expect(subject.respond_to?(:boom_shakalaka)).to eq true
    end
  end
end
