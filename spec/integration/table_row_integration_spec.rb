require 'spec_helper'

SimpleCov.command_name('TableRow') unless RUBY_VERSION.to_s < '1.9.0'

describe 'TableRow, Integration' do

  let(:clazz) { CukeModeler::TableRow }


  describe 'unique behavior' do

    describe 'getting ancestors' do

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
        ancestor = table_row.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = table_row.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = table_row.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.features.first
      end

      context 'a table row that is part of a scenario' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Scenario: Test test
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:table_row) { directory.feature_files.first.features.first.tests.first.steps.first.block.row_elements.first }


        it 'can get its scenario' do
          ancestor = table_row.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      context 'a table row that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Scenario Outline: Test outline
                        * a step:
                          | a | table |
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:table_row) { directory.feature_files.first.features.first.tests.first.steps.first.block.row_elements.first }


        it 'can get its outline' do
          ancestor = table_row.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      context 'a table row string that is part of a background' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Background: Test background
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:table_row) { directory.feature_files.first.features.first.background.steps.first.block.row_elements.first }


        it 'can get its background' do
          ancestor = table_row.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.background)
        end

      end

      it 'can get its step' do
        ancestor = table_row.get_ancestor(:step)

        ancestor.should equal directory.feature_files.first.features.first.tests.first.steps.first
      end

      it 'can get its table' do
        ancestor = table_row.get_ancestor(:table)

        ancestor.should equal directory.feature_files.first.features.first.tests.first.steps.first.block
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = table_row.get_ancestor(:example)

        ancestor.should be_nil
      end

    end

  end

end
