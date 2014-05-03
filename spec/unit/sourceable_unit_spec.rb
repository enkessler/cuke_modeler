require 'spec_helper'

SimpleCov.command_name('Sourceable') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Sourceable, Unit' do

  nodule = CukeModeler::Sourceable

  before(:each) do
    @element = Object.new.extend(nodule)
  end


  it 'has a source line' do
    @element.should respond_to(:source_line)
  end

end
