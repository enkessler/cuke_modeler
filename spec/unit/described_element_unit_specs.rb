require 'spec_helper'

shared_examples_for 'a described element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a description' do
    expect(element).to respond_to(:description)
    expect(element).to respond_to(:description_text)
  end

  it 'can change its description' do
    expect(element).to respond_to(:description=)
    expect(element).to respond_to(:description_text=)

    element.description = :some_description
    expect(element.description).to eq(:some_description)
    element.description = :some_other_description
    expect(element.description).to eq(:some_other_description)

    element.description_text = :some_description
    expect(element.description_text).to eq(:some_description)
    element.description_text = :some_other_description
    expect(element.description_text).to eq(:some_other_description)
  end

  it 'starts with no description' do
    expect(element.description).to eq('')
    expect(element.description_text).to eq([])
  end

end
