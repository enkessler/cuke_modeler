require 'spec_helper'

SimpleCov.command_name('Table') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Table, Integration' do

  let(:clazz) { CukeModeler::Table }


  it 'properly sets its child elements' do
    source = ['| cell 1 |',
              '| cell 2 |']
    source = source.join("\n")

    table = clazz.new(source)
    row_1 = table.row_elements[0]
    row_2 = table.row_elements[1]

    row_1.parent_element.should equal table
    row_2.parent_element.should equal table
  end

  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature',
                '',
                '  Scenario: Test test',
                '    * a step:',
                '      | a | table |']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/table_row_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:table) { directory.feature_files.first.features.first.tests.first.steps.first.block }


    it 'can get its directory' do
      gotten_directory = table.get_ancestor(:directory)

      gotten_directory.should equal directory
    end

    it 'can get its feature file' do
      gotten_feature_file = table.get_ancestor(:feature_file)

      gotten_feature_file.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      gotten_feature = table.get_ancestor(:feature)

      gotten_feature.should equal directory.feature_files.first.features.first
    end

    it 'can get its test' do
      gotten_test = table.get_ancestor(:test)

      gotten_test.should equal directory.feature_files.first.features.first.tests.first
    end

    it 'can get its step' do
      gotten_step = table.get_ancestor(:step)

      gotten_step.should equal directory.feature_files.first.features.first.tests.first.steps.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_example = table.get_ancestor(:example)

      gotten_example.should be_nil
    end

  end

  context 'table output edge cases' do
    # todo - remove once #contents is no longer supported
    it 'can output a table that only has row elements' do
      table = clazz.new
      table.row_elements = [CukeModeler::TableRow.new]

      expect { table.to_s }.to_not raise_error
    end

  end
end
