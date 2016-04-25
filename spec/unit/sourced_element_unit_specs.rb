require 'spec_helper'

shared_examples_for 'a sourced element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a source line - #source_line' do
    element.should respond_to(:source_line)
  end

  it 'starts with no source line' do
    element.source_line.should == nil
  end

end
