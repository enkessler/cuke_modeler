require 'spec_helper'

SimpleCov.command_name('TableRow') unless RUBY_VERSION.to_s < '1.9.0'

describe 'TableRow, Integration' do

  let(:clazz) { CukeModeler::TableRow }


  describe 'getting stuff' do

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
    let(:table_row) { directory.feature_files.first.features.first.tests.first.steps.first.block.row_elements.first }


    it 'can get its directory' do
      gotten_directory = table_row.get_ancestor(:directory)

      gotten_directory.should equal directory
    end

    it 'can get its feature file' do
      gotten_feature_file = table_row.get_ancestor(:feature_file)

      gotten_feature_file.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      gotten_feature = table_row.get_ancestor(:feature)

      gotten_feature.should equal directory.feature_files.first.features.first
    end

    it 'can get its test' do
      gotten_test = table_row.get_ancestor(:test)

      gotten_test.should equal directory.feature_files.first.features.first.tests.first
    end

    it 'can get its step' do
      gotten_step = table_row.get_ancestor(:step)

      gotten_step.should equal directory.feature_files.first.features.first.tests.first.steps.first
    end

    it 'can get its table' do
      gotten_table = table_row.get_ancestor(:table)

      gotten_table.should equal directory.feature_files.first.features.first.tests.first.steps.first.block
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_example = table_row.get_ancestor(:example)

      gotten_example.should be_nil
    end

  end
end
