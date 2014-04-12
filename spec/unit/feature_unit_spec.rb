require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Unit' do

  clazz = CukeModeler::Feature

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
    it_should_behave_like 'a named element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @feature = clazz.new
    end

  end
end
