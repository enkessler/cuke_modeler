require 'spec_helper'

shared_examples_for 'a containing element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has children' do
    expect(element).to respond_to(:children)
  end

  it 'returns a collection of children' do
    expect(element.children).to be_an(Array)
  end

end
