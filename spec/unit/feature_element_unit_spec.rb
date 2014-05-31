require 'spec_helper'

SimpleCov.command_name('FeatureElement') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureElement, Unit' do

  clazz = CukeModeler::FeatureElement

  it_should_behave_like 'a feature element', clazz
  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a prepopulated element', clazz
  it_should_behave_like 'a bare bones element', clazz


  before(:each) do
    @element = clazz.new
  end

end
