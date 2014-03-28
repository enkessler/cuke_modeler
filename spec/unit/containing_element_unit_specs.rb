require 'spec_helper'

shared_examples_for 'a containing element' do |clazz|

  before(:each) do
    @element = clazz.new
  end

  it 'has children' do
    @element.should respond_to(:contains)
  end

  it 'returns its children in a collection' do
    @element.contains.is_a?(Array).should be_true
  end

end
