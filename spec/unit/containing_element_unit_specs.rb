require 'spec_helper'

shared_examples_for 'a containing element' do

  # clazz must be defined by the calling file

  before(:each) do
    @element = clazz.new
  end

  it 'has children - #contains' do
    @element.should respond_to(:contains)
  end

  it 'returns a collection of children - #contains' do
    @element.contains.is_a?(Array).should be_true
  end

end
