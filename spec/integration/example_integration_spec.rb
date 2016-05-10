require 'spec_helper'

SimpleCov.command_name('Example') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Example, Integration' do

  let(:clazz) { CukeModeler::Example }


  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['@a_tag',
                'Examples:',
                '  | param   |',
                '  | value 1 |']
      source = source.join("\n")

      example = clazz.new(source)
      rows = example.row_elements
      tag = example.tag_elements.first

      expect(rows[0].parent_element).to equal(example)
      expect(rows[1].parent_element).to equal(example)
      expect(tag.parent_element).to equal(example)
    end

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

        file_path = "#{@default_file_directory}/example_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:example) { directory.feature_files.first.features.first.tests.first.examples.first }


      it 'can get its directory' do
        ancestor = example.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = example.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = example.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.features.first)
      end

      context 'an example that is part of an outline' do

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
        let(:example) { directory.feature_files.first.features.first.tests.first.examples.first }


        it 'can get its outline' do
          ancestor = example.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.features.first.tests.first)
        end

      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = example.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end

    describe 'example output edge cases' do

      context 'a new example object' do

        let(:example) { clazz.new }


        it 'can output an example that has only tag elements' do
          example.tag_elements = [CukeModeler::Tag.new]

          expect { example.to_s }.to_not raise_error
        end

        #todo - remove once Hash rows are no longer supported
        it 'can output an example that has only row elements' do
          example.row_elements = [CukeModeler::Row.new]

          expect { example.to_s }.to_not raise_error
        end

      end

    end

  end

end
