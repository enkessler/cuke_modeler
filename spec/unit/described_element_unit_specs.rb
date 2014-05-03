require 'spec_helper'

shared_examples_for 'a described element' do |clazz|

  before(:each) do
    @described_element = clazz.new
  end

  it 'has a description' do
    @described_element.should respond_to(:description)
  end

  it 'can change its description' do
    @described_element.should respond_to(:description=)

    @described_element.description = :some_description
    @described_element.description.should == :some_description
    @described_element.description = :some_other_description
    @described_element.description.should == :some_other_description
  end

  it 'starts with no description' do
    @described_element.description.should == ''
  end

end
