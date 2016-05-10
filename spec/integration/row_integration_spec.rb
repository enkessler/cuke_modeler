require 'spec_helper'

SimpleCov.command_name('Row') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Row, Integration' do

  let(:clazz) { CukeModeler::Row }


  describe 'unique behavior' do

    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario Outline: Test test',
                  '    * a step',
                  '  Examples: Test example',
                  '    | a param |',
                  '    | a value |']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/row_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:row) { directory.feature_files.first.features.first.tests.first.examples.first.row_elements.first }


      it 'can get its directory' do
        ancestor = row.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = row.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = row.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.features.first
      end

      context 'a row that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                      
                      Scenario Outline: Test outline
                        * a step
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/step_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:row) { directory.feature_files.first.features.first.tests.first.examples.first.row_elements.first }


        it 'can get its outline' do
          ancestor = row.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      it 'can get its example' do
        ancestor = row.get_ancestor(:example)

        ancestor.should equal directory.feature_files.first.features.first.tests.first.examples.first
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = row.get_ancestor(:table)

        ancestor.should be_nil
      end

    end

  end

end
