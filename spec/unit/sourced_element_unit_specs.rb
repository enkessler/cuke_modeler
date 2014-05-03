require 'spec_helper'

shared_examples_for 'a sourced element' do |clazz|

  before(:each) do
    @element = clazz.new
  end


  it 'has a source line' do
    @element.should respond_to(:source_line)
  end

  it 'starts with no source line' do
    @element.source_line.should == nil
  end

end
