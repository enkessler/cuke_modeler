require 'spec_helper'

SimpleCov.command_name('Parsing') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Parsing, Unit' do

  nodule = CukeModeler::Parsing

  it 'can parse text' do
    nodule.should respond_to(:parse_text)
  end

  it 'requires text to parse' do
    nodule.method(:parse_text).arity.should == 1
  end

  it 'can only parse strings' do
    expect { nodule.parse_text(5) }.to raise_error(ArgumentError)
    expect { nodule.parse_text('Feature:') }.to_not raise_error
  end

  it 'returns an Array' do
    result = nodule.parse_text('Feature:')
    result.is_a?(Array).should be_true
  end

end
