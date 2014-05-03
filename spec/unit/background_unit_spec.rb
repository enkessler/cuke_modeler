require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Unit' do

  clazz = CukeModeler::Background

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
    it_should_behave_like 'a named element', clazz
  end

  describe 'specific tests' do
    # None so far
  end

end
