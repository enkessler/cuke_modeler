require 'spec_helper'

shared_examples_for 'a raw element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has an underlying implementation representation' do
    expect(element).to respond_to(:raw_element)
  end

  it 'can change its underlying implementation representation' do
    expect(element).to respond_to(:raw_element=)

    element.raw_element = :some_raw_element
    expect(element.raw_element).to eq(:some_raw_element)
    element.raw_element = :some_other_raw_element
    expect(element.raw_element).to eq(:some_other_raw_element)
  end


  describe 'abstract instantiation' do

    context 'a new raw object' do

      let(:element) { clazz.new }


      it 'starts with no underlying implementation representation' do
        expect(element.raw_element).to be_nil
      end

    end

  end

end
