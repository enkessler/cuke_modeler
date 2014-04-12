require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Integration' do

  clazz = CukeModeler::FeatureFile


  it 'cannot model a non-existent feature file' do
    path = "#{@default_file_directory}/missing_file.txt"

    expect { clazz.new(path) }.to raise_error(ArgumentError)
  end

  it 'properly sets its child elements' do
    file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

    File.open(file_path, "w") { |file|
      file.puts('Feature: Test feature')
    }

    file = clazz.new(file_path)
    feature = file.feature

    feature.parent_element.should equal file
  end

  describe 'getting ancestors' do

    before(:each) do
      FileUtils.touch("#{@default_file_directory}/#{@default_feature_file_name}")

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @feature_file = @directory.feature_files.first
    end


    it 'can get its directory' do
      ancestor = @feature_file.get_ancestor(:directory)

      ancestor.should equal @directory
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = clazz.new.get_ancestor(:directory)

      ancestor.should be_nil
    end

  end
end
