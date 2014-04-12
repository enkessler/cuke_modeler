require 'spec_helper'

SimpleCov.command_name('Named') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Named, Unit' do

  nodule = CukeModeler::Named

  before(:each) do
    @named_element = Object.new.extend(nodule)
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

end
