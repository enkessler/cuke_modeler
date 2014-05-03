require 'spec_helper'

SimpleCov.command_name('Scenario') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Scenario, Unit' do

  clazz = CukeModeler::Scenario

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
    it_should_behave_like 'a named element', clazz
  end

end
