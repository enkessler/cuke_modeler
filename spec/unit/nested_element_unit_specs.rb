require 'spec_helper'

shared_examples_for 'a nested element' do

  # clazz must be defined by the calling file

  before(:each) do
    @nested_element = clazz.new
  end

  it 'has a parent element - #parent_element' do
    @nested_element.should respond_to(:parent_element)
  end

  it 'can get and set its parent element - #parent_element, #parent_element=' do
    @nested_element.parent_element = :some_parent_element
    @nested_element.parent_element.should == :some_parent_element
    @nested_element.parent_element = :some_other_parent_element
    @nested_element.parent_element.should == :some_other_parent_element
  end

  it 'starts with no parent element' do
    @nested_element.parent_element.should == nil
  end

  it 'has access to its ancestors' do
    @nested_element.should respond_to(:get_ancestor)
  end

  it 'gets an ancestor based on type' do
    (clazz.instance_method(:get_ancestor).arity == 1).should be_true
  end

  it 'raises and exception if an unknown ancestor type is requested' do
    expect { @nested_element.get_ancestor(:bad_ancestor_type) }.to raise_exception(ArgumentError)
  end

end
