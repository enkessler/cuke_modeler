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


    it 'has a path' do
      @feature_file.should respond_to(:path)
    end

    it 'can change its path' do
      @feature_file.should respond_to(:path=)

      @feature_file.path = :some_path
      @feature_file.path.should == :some_path
      @feature_file.path = :some_other_path
      @feature_file.path.should == :some_other_path
    end

    it 'starts with no path' do
      @feature_file.path.should == ''
    end

    it 'has a name' do
      @feature_file.should respond_to(:name)
    end

    it 'starts with no name' do
      @feature_file.name.should == ''
    end

    it 'has a feature' do
      @feature_file.should respond_to(:feature)
    end

    it 'can change its feature' do
      @feature_file.should respond_to(:feature=)

      @feature_file.feature = :some_feature
      @feature_file.feature.should == :some_feature
      @feature_file.feature = :some_other_feature
      @feature_file.feature.should == :some_other_feature
    end

    it 'starts with no feature' do
      @feature_file.feature.should == nil
    end

    it 'contains a feature' do
      feature = :a_feature
      everything = [feature]

      @feature_file.feature = feature

      @feature_file.contains.should =~ everything
    end

    describe 'feature file output edge cases' do

      it 'can output an empty feature file' do
        expect { @feature_file.to_s }.to_not raise_error
      end

    end
  end
end
