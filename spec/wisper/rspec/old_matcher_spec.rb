require_relative '../../../lib/wisper/rspec/matchers'

describe 'including mis-capitalized matcher' do
  it 'raises an exception' do
    expect do
      Class.new.send(:include, Wisper::Rspec::BroadcastMatcher)
    end.to raise_error(/include Wisper::RSpec::BroadcastMatcher instead of/)
  end
end
