require "#{File.dirname(__FILE__)}/../../spec_helper"

shared_examples_for 'a containing model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has children' do
    expect(model).to respond_to(:children)
  end

  it 'returns a collection of children' do
    expect(model.children).to be_an(Array)
  end

end
