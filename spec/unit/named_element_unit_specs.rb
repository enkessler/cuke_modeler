require 'spec_helper'

shared_examples_for 'a named element' do |clazz|

  before(:each) do
    @named_element = clazz.new
  end

  it 'has a name' do
    @named_element.should respond_to(:name)
  end

  it 'can change its name' do
    @named_element.should respond_to(:name=)

    @named_element.name = :some_name
    @named_element.name.should == :some_name
    @named_element.name = :some_other_name
    @named_element.name.should == :some_other_name
  end

  it 'starts with no name' do
    @named_element.name.should == ''
  end

end
