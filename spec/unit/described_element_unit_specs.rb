require 'spec_helper'

shared_examples_for 'a described element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a description' do
    expect(element).to respond_to(:description)
  end

  it 'can change its description' do
    expect(element).to respond_to(:description=)

    element.description = :some_description
    expect(element.description).to eq(:some_description)
    element.description = :some_other_description
    expect(element.description).to eq(:some_other_description)
  end

  it 'starts with no description' do
    expect(element.description).to eq('')
  end

end
