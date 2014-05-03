require 'spec_helper'

SimpleCov.command_name('Described') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Described, Unit' do

  nodule = CukeModeler::Described

  before(:each) do
    @described_element = Object.new.extend(nodule)
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

end
