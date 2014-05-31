require 'spec_helper'

SimpleCov.command_name('Raw') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Raw, Unit' do

  nodule = CukeModeler::Raw

  before(:each) do
    @element = Object.new.extend(nodule)
  end


  it 'has a raw element - #raw_element' do
    @element.should respond_to(:raw_element)
  end

  it 'can get and set its raw element - #raw_element, #raw_element=' do
    @element.raw_element = :some_raw_element
    @element.raw_element.should == :some_raw_element
    @element.raw_element = :some_other_raw_element
    @element.raw_element.should == :some_other_raw_element
  end

end
