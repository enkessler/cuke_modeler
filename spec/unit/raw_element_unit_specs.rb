require 'spec_helper'

shared_examples_for 'a raw element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has an underlying implementation representation' do
    element.should respond_to(:raw_element)
  end

  it 'can change its underlying implementation representation' do
    expect(element).to respond_to(:raw_element=)

    element.raw_element = :some_raw_element
    element.raw_element.should == :some_raw_element
    element.raw_element = :some_other_raw_element
    element.raw_element.should == :some_other_raw_element
  end

  it 'starts with no underlying implementation representation' do
    element.raw_element.should == nil
  end

end
