require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Unit' do

  clazz = CukeModeler::FeatureFile

  describe 'generic tests' do
    it_should_behave_like 'a modeled element', clazz
  end

  describe 'specific tests' do

    before(:each) do
      @feature_file = clazz.new
    end


    it 'has a name' do
      @feature_file.should respond_to(:name)
    end

    it 'starts with no name' do
      @feature_file.name.should == ''
    end

  end
end
