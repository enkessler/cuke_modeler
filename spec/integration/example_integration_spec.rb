require 'spec_helper'

SimpleCov.command_name('Example') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Example, Integration' do

  it 'properly sets its child elements' do
    source = ['@a_tag',
              'Examples:',
              '  | param   |',
              '  | value 1 |']
    source = source.join("\n")

    example = CukeModeler::Example.new(source)
    rows = example.row_elements
    tag = example.tag_elements.first

    rows[0].parent_element.should equal example
    rows[1].parent_element.should equal example
    tag.parent_element.should equal example
  end

  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature',
                '',
                '  Scenario Outline: Test test',
                '    * a step',
                '  Examples: Test example',
                '    | a param |',
                '    | a value |']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/example_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @example = @directory.feature_files.first.features.first.tests.first.examples.first
    end


    it 'can get its directory' do
      directory = @example.get_ancestor(:directory)

      directory.should equal @directory
    end

    it 'can get its feature file' do
      feature_file = @example.get_ancestor(:feature_file)

      feature_file.should equal @directory.feature_files.first
    end

    it 'can get its feature' do
      feature = @example.get_ancestor(:feature)

      feature.should equal @directory.feature_files.first.features.first
    end

    it 'can get its test' do
      test = @example.get_ancestor(:test)

      test.should equal @directory.feature_files.first.features.first.tests.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      example = @example.get_ancestor(:example)

      example.should be_nil
    end

  end

  context 'example output edge cases' do

    before(:each) do
      @example = CukeModeler::Example.new
    end

    it 'can output an example that has only a tag elements' do
      @example.tag_elements = [CukeModeler::Tag.new]

      expect { @example.to_s }.to_not raise_error
    end

    #todo - remove once Hash rows are no longer supported
    it 'can output an example that has only row elements' do
      @example.row_elements = [CukeModeler::Row.new]

      expect { @example.to_s }.to_not raise_error
    end

  end
end
