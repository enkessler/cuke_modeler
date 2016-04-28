require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Unit' do

  let(:clazz) { CukeModeler::FeatureFile }

  it_should_behave_like 'a nested element'
  it_should_behave_like 'a containing element'
  it_should_behave_like 'a bare bones element'
  it_should_behave_like 'a prepopulated element'


  let(:feature_file) { clazz.new }


  it 'provides its own filename when being parsed' do
    path = "#{@default_file_directory}/#{@default_feature_file_name}"
    File.open(path, "w") { |file| file.puts 'bad feature text' }

    expect { clazz.new(path) }.to raise_error(/'#{path}'/)
  end

  it 'knows the name of the file that it is modeling' do
    path = "#{@default_file_directory}/#{@default_feature_file_name}"
    File.open(path, "w") { |file| file.puts "Feature:" }

    feature = clazz.new(path)

    feature.name.should == @default_feature_file_name
  end

  it 'knows the path of the file that it is modeling' do
    path = "#{@default_file_directory}/#{@default_feature_file_name}"
    File.open(path, "w") { |file| file.puts "Feature:" }

    file = clazz.new(path)

    file.path.should == path
  end

  it 'has features - #features' do
    feature_file.should respond_to(:features)
  end

  it 'can get and set its features - #features, #features=' do
    feature_file.features = :some_features
    feature_file.features.should == :some_features
    feature_file.features = :some_other_features
    feature_file.features.should == :some_other_features
  end

  it 'knows how many features it has - #feature_count' do
    feature_file.features = [:a_feature]
    feature_file.feature_count.should == 1
    feature_file.features = []
    feature_file.feature_count.should == 0
  end

  it 'starts with no features' do
    feature_file.features.should == []
  end

  it 'contains features' do
    features = [:a_feature]
    everything = features

    feature_file.features = features

    feature_file.contains.should =~ everything
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

    it 'can output an empty feature file' do
      expect { feature_file.to_s }.to_not raise_error
    end

  end

end
