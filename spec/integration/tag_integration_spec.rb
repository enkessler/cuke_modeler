require 'spec_helper'

SimpleCov.command_name('Tag') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Tag, Integration' do

  let(:clazz) { CukeModeler::Tag }


  context 'getting stuff' do

    before(:each) do
      source = ['@feature_tag',
                'Feature: Test feature',
                '',
                '  Scenario Outline: Test test',
                '    * a step',
                '',
                '  @example_tag',
                '  Examples: Test example',
                '    | a param |',
                '    | a value |']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/tag_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:tag) { directory.feature_files.first.features.first.tests.first.examples.first.tag_elements.first }
    let(:high_level_tag) { directory.feature_files.first.features.first.tag_elements.first }


    it 'can get its directory' do
      gotten_directory = tag.get_ancestor(:directory)

      gotten_directory.should equal directory
    end

    it 'can get its feature file' do
      gotten_feature_file = tag.get_ancestor(:feature_file)

      gotten_feature_file.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      gotten_feature = tag.get_ancestor(:feature)

      gotten_feature.should equal directory.feature_files.first.features.first
    end

    it 'can get its test' do
      gotten_test = tag.get_ancestor(:test)

      gotten_test.should equal directory.feature_files.first.features.first.tests.first
    end

    it 'can get its example' do
      gotten_example = tag.get_ancestor(:example)

      gotten_example.should equal directory.feature_files.first.features.first.tests.first.examples.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_example = high_level_tag.get_ancestor(:example)

      gotten_example.should be_nil
    end

  end
end
