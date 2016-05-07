require 'spec_helper'

shared_examples_for 'a containing element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has children' do
    element.should respond_to(:children)
  end

  it 'returns a collection of children' do
    element.children.is_a?(Array).should be_true
  end

end
