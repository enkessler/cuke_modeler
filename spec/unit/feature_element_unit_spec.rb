require 'spec_helper'

SimpleCov.command_name('FeatureElement') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureElement, Unit' do

  let(:clazz) { CukeModeler::FeatureElement }

  it_should_behave_like 'a feature element'
  it_should_behave_like 'a nested element'
  it_should_behave_like 'a prepopulated element'
  it_should_behave_like 'a bare bones element'

  let(:element) { clazz.new }

end
