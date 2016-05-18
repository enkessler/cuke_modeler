require 'spec_helper'

SimpleCov.command_name('Table') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Table, Integration' do

  let(:clazz) { CukeModeler::Table }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['| cell 1 |',
                '| cell 2 |']
      source = source.join("\n")

      table = clazz.new(source)
      row_1 = table.rows[0]
      row_2 = table.rows[1]

      row_1.parent_element.should equal table
      row_2.parent_element.should equal table
    end

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
      let(:table) { directory.feature_files.first.features.first.tests.first.steps.first.block }


      it 'can get its directory' do
        ancestor = table.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = table.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = table.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.features.first
      end

      context 'a table that is part of a scenario' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Scenario: Test test
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:table) { directory.feature_files.first.features.first.tests.first.steps.first.block }


        it 'can get its scenario' do
          ancestor = table.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      context 'a table that is part of an outline' do

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
        let(:table) { directory.feature_files.first.features.first.tests.first.steps.first.block }


        it 'can get its outline' do
          ancestor = table.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      context 'a table that is part of a background' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Background: Test background
                        * a step:
                          | a | table |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:table) { directory.feature_files.first.features.first.background.steps.first.block }


        it 'can get its background' do
          ancestor = table.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.background)
        end

      end

      it 'can get its step' do
        ancestor = table.get_ancestor(:step)

        ancestor.should equal directory.feature_files.first.features.first.tests.first.steps.first
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = table.get_ancestor(:example)

        ancestor.should be_nil
      end

    end

    describe 'table output edge cases' do

      context 'a new table object' do

        let(:table) { clazz.new }


        it 'can output a table that only has row elements' do
          table.rows = [CukeModeler::TableRow.new]

          expect { table.to_s }.to_not raise_error
        end

      end

    end

  end

end
