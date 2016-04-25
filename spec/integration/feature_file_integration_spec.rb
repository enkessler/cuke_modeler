require 'spec_helper'

SimpleCov.command_name('FeatureFile') unless RUBY_VERSION.to_s < '1.9.0'

describe 'FeatureFile, Integration' do

  let(:clazz) { CukeModeler::FeatureFile }


  it 'properly sets its child elements' do
    file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

    File.open(file_path, "w") { |file|
      file.puts('Feature: Test feature')
    }

    file = clazz.new(file_path)
    feature = file.feature

    expect(feature.parent_element).to equal(file)
  end

  context 'getting stuff' do

    before(:each) do
      file_path = "#{@default_file_directory}/feature_file_test_file.feature"
      File.open(file_path, 'w') { |file| file.write('Feature: Test feature') }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:feature_file) { directory.feature_files.first }


    it 'can get its directory' do
      gotten_directory = feature_file.get_ancestor(:directory)

      expect(gotten_directory).to equal(directory)
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_example = feature_file.get_ancestor(:example)

      expect(gotten_example).to be_nil
    end

  end
end
