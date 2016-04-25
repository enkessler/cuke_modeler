require 'spec_helper'

shared_examples_for 'a raw element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has an underlying implementation representation - #raw_element' do
    element.should respond_to(:raw_element)
  end

  it 'can get and set its underlying implementation representation - #raw_element, #raw_element=' do
    element.raw_element = :some_raw_element
    element.raw_element.should == :some_raw_element
    element.raw_element = :some_other_raw_element
    element.raw_element.should == :some_other_raw_element
  end

  it 'starts with no underlying implementation representation' do
    element.raw_element.should == nil
  end

end
