require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Unit' do

  let(:clazz) { CukeModeler::FeatureFile }
  let(:feature_file) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'

  end


  describe 'unique behavior' do

    # todo - this is an integration test
    it 'provides its own filename when being parsed' do
      path = "#{@default_file_directory}/#{@default_feature_file_name}"
      File.open(path, "w") { |file| file.puts 'bad feature text' }

      expect { clazz.new(path) }.to raise_error(/'#{path}'/)
    end

    # todo - this is an integration test
    it 'knows the name of the file that it is modeling' do
      path = "#{@default_file_directory}/#{@default_feature_file_name}"
      File.open(path, "w") { |file| file.puts "Feature:" }

      feature_file = clazz.new(path)

      feature_file.name.should == @default_feature_file_name
    end

    it 'has a path' do
      expect(feature_file).to respond_to(:path)
    end

    it 'can change its path' do
      expect(feature_file).to respond_to(:path=)

      feature_file.path = :some_path
      feature_file.path.should == :some_path
      feature_file.path = :some_other_path
      feature_file.path.should == :some_other_path
    end

    # todo - this is an integration test
    it 'knows the path of the file that it is modeling' do
      path = "#{@default_file_directory}/#{@default_feature_file_name}"
      File.open(path, "w") { |file| file.puts "Feature:" }

      file = clazz.new(path)

      file.path.should == path
    end

    it 'has features' do
      feature_file.should respond_to(:features)
    end

    it 'can change its features' do
      expect(feature_file).to respond_to(:features=)

      feature_file.features = :some_features
      feature_file.features.should == :some_features
      feature_file.features = :some_other_features
      feature_file.features.should == :some_other_features
    end

    it 'knows how many features it has' do
      feature_file.features = [:a_feature]
      feature_file.feature_count.should == 1
      feature_file.features = []
      feature_file.feature_count.should == 0
    end

    describe 'abstract instantiation' do

      it 'starts with no path' do
        expect(feature_file.path).to be nil
      end

      it 'starts with no name' do
        expect(feature_file.name).to be nil
      end

      it 'starts with no features' do
        feature_file.features.should == []
      end

    end

    it 'contains features' do
      features = [:a_feature]
      everything = features

      feature_file.features = features

      feature_file.children.should =~ everything
    end

    it 'can easily access its sole feature' do
      feature_file.features = []
      feature_file.feature.should be_nil

      feature_file.features = [:a_feature]
      feature_file.feature.should == :a_feature
    end


    describe 'feature file output edge cases' do

      it 'is a String' do
        feature_file.to_s.should be_a(String)
      end


      context 'a new feature file object' do

        let(:feature_file) { clazz.new }


        it 'can output an empty feature file' do
          expect { feature_file.to_s }.to_not raise_error
        end

      end

    end

  end

end
