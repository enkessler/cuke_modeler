require 'spec_helper'

SimpleCov.command_name('Example') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Example, Integration' do

  let(:clazz) { CukeModeler::Example }
  let(:example) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin', :gherkin3 => true do
      source = ['Examples:',
                '|param|',
                '|value|']
      source = source.join("\n")

      expect { @element = clazz.new(source) }.to_not raise_error
    end

    it 'can be instantiated with the minimum viable Gherkin', :gherkin2 => true do
      source = ['Examples:',
                '|param|']
      source = source.join("\n")

      expect { @element = clazz.new(source) }.to_not raise_error
    end

    it 'properly sets its child elements' do
      source = ['@a_tag',
                'Examples:',
                '  | param   |',
                '  | value 1 |']
      source = source.join("\n")

      example = clazz.new(source)
      rows = example.rows
      tag = example.tags.first

      expect(rows[0].parent_model).to equal(example)
      expect(rows[1].parent_model).to equal(example)
      expect(tag.parent_model).to equal(example)
    end

    it 'does not include the parameter row when accessing argument rows' do
      source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|"
      example = clazz.new(source)

      rows = example.argument_rows

      expect(rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', 'value4']])
    end

    it 'does not include argument rows when accessing the parameter row' do
      source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|"
      example = clazz.new(source)

      row = example.parameter_row

      expect(row.cells).to eq(['param1', 'param2'])
    end


    describe 'adding rows' do

      it 'can add a new row as a hash, string values' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        new_row = {'param1' => 'value3', 'param2' => 'value4'}
        example.add_row(new_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', 'value4']])
      end

      it 'can add a new row as a hash, non-string values' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        new_row = {:param1 => 'value3', 'param2' => 4}
        example.add_row(new_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', '4']])
      end

      it 'can add a new row as a hash, random key order' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        new_row = {'param2' => 'value4', 'param1' => 'value3'}
        example.add_row(new_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', 'value4']])
      end

      it 'can add a new row as an array, string values' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        new_row = ['value3', 'value4']
        example.add_row(new_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', 'value4']])
      end

      it 'can add a new row as an array, non-string values' do
        source = "Examples:\n|param1|param2|param3|\n|value1|value2|value3|"
        example = clazz.new(source)

        new_row = [:value4, 5, 'value6']
        example.add_row(new_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2', 'value3'], ['value4', '5', 'value6']])
      end

      it 'can only use a Hash or an Array to add a new row' do
        source = "Examples:\n|param|\n|value|"
        example = clazz.new(source)

        expect { example.add_row({}) }.to_not raise_error
        expect { example.add_row([]) }.to_not raise_error
        expect { example.add_row(:a_row) }.to raise_error(ArgumentError)
      end

      it 'trims whitespace from added rows' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        hash_row = {'param1' => 'value3  ', 'param2' => '  value4'}
        array_row = ['value5', ' value6 ']
        example.add_row(hash_row)
        example.add_row(array_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2'], ['value3', 'value4'], ['value5', 'value6']])
      end

      it 'will complain if a row is added and no parameters have been set' do
        example = clazz.new
        example.rows = []

        new_row = ['value1', 'value2']
        expect { example.add_row(new_row) }.to raise_error('Cannot add a row. No parameters have been set.')

        new_row = {'param1' => 'value1', 'param2' => 'value2'}
        expect { example.add_row(new_row) }.to raise_error('Cannot add a row. No parameters have been set.')
      end

      it 'does not modify its row input' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        array_row = ['value1'.freeze, 'value2'.freeze].freeze
        expect { example.add_row(array_row) }.to_not raise_error

        hash_row = {'param1'.freeze => 'value1'.freeze, 'param2'.freeze => 'value2'.freeze}.freeze
        expect { example.add_row(hash_row) }.to_not raise_error
      end

    end


    describe 'removing rows' do

      it 'can remove an existing row as a hash' do
        source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|"
        example = clazz.new(source)

        old_row = {'param1' => 'value3', 'param2' => 'value4'}
        example.remove_row(old_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2']])
      end

      it 'can remove an existing row as a hash, random key order' do
        source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|"
        example = clazz.new(source)

        old_row = {'param2' => 'value4', 'param1' => 'value3'}
        example.remove_row(old_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2']])
      end

      it 'can remove an existing row as an array' do
        source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|"
        example = clazz.new(source)

        old_row = ['value3', 'value4']
        example.remove_row(old_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2']])
      end

      it 'can only use a Hash or an Array to remove an existing row' do
        expect { example.remove_row({}) }.to_not raise_error
        expect { example.remove_row([]) }.to_not raise_error
        expect { example.remove_row(:a_row) }.to raise_error(ArgumentError)
      end

      it 'trims whitespace from removed rows' do
        source = "Examples:\n|param1|param2|\n|value1|value2|\n|value3|value4|\n|value5|value6|"
        example = clazz.new(source)

        hash_row = {'param1' => 'value3  ', 'param2' => '  value4'}
        array_row = ['value5', ' value6 ']

        # todo - test these separately
        example.remove_row(hash_row)
        example.remove_row(array_row)

        expect(example.argument_rows.collect { |row| row.cells }).to eq([['value1', 'value2']])
      end

      it 'can gracefully remove a row from an example that has no rows' do
        example = clazz.new
        example.rows = []

        expect { example.remove_row({}) }.to_not raise_error
        expect { example.remove_row([]) }.to_not raise_error
      end

      it 'will not remove the parameter row' do
        source = "Examples:\n|param1|param2|\n|value1|value2|"
        example = clazz.new(source)

        hash_row = {'param1' => 'param1  ', 'param2' => '  param2'}
        array_row = ['param1', ' param2 ']

        example.remove_row(hash_row)
        expect(example.rows.collect { |row| row.cells }).to eq([['param1', 'param2'], ['value1', 'value2']])

        example.remove_row(array_row)
        expect(example.rows.collect { |row| row.cells }).to eq([['param1', 'param2'], ['value1', 'value2']])
      end

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
      let(:example) { directory.feature_files.first.feature.tests.first.examples.first }


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

        expect(ancestor).to equal(directory.feature_files.first.feature)
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
        let(:example) { directory.feature_files.first.feature.tests.first.examples.first }


        it 'can get its outline' do
          ancestor = example.get_ancestor(:test)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
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


        it 'can output an example that has only tags' do
          example.tags = [CukeModeler::Tag.new]

          expect { example.to_s }.to_not raise_error
        end

        it 'can output an example that has only rows' do
          example.rows = [CukeModeler::Row.new]

          expect { example.to_s }.to_not raise_error
        end

      end

    end

  end

end
