require 'spec_helper'

SimpleCov.command_name('Parsing') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Parsing, Unit' do

  it 'can parse text - #parse_text' do
    CukeModeler::Parsing.should respond_to(:parse_text)
  end

  it 'can only parse strings' do
    expect{CukeModeler::Parsing.parse_text(5)}.to raise_error(ArgumentError)
    expect{CukeModeler::Parsing.parse_text('Feature:')}.to_not raise_error
  end

  it 'returns an Array' do
    result = CukeModeler::Parsing.parse_text('Feature:')
    result.is_a?(Array).should be_true
  end

end
