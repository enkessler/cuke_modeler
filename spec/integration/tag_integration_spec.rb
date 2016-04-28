require 'spec_helper'

SimpleCov.command_name('Tag') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Tag, Integration' do

  let(:clazz) { CukeModeler::Tag }


  describe 'getting ancestors' do

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
      ancestor = tag.get_ancestor(:directory)

      ancestor.should equal directory
    end

    it 'can get its feature file' do
      ancestor = tag.get_ancestor(:feature_file)

      ancestor.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      ancestor = tag.get_ancestor(:feature)

      ancestor.should equal directory.feature_files.first.features.first
    end

    it 'can get its test' do
      ancestor = tag.get_ancestor(:test)

      ancestor.should equal directory.feature_files.first.features.first.tests.first
    end

    it 'can get its example' do
      ancestor = tag.get_ancestor(:example)

      ancestor.should equal directory.feature_files.first.features.first.tests.first.examples.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = high_level_tag.get_ancestor(:example)

      ancestor.should be_nil
    end

  end
end
