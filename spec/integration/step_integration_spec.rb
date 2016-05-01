require 'spec_helper'

SimpleCov.command_name('Step') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Step, Integration' do

  let(:clazz) { CukeModeler::Step }


  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source_1 = ['* a step',
                  '"""',
                  'a doc string',
                  '"""']
      source_2 = ['* a step',
                  '| a block|']

      step_1 = clazz.new(source_1.join("\n"))
      step_2 = clazz.new(source_2.join("\n"))


      doc_string = step_1.block
      table = step_2.block

      doc_string.parent_element.should equal step_1
      table.parent_element.should equal step_2
    end

    it 'defaults to the World delimiters if its own are not set' do
      world = CukeModeler::World
      world.left_delimiter = '"'
      world.right_delimiter = '"'

      step = clazz.new
      step.right_delimiter = nil
      step.left_delimiter = nil

      step.right_delimiter.should == '"'
      step.left_delimiter.should == '"'
    end

    it 'attempts to determine its arguments during creation' do
      source = 'Given a test step with *parameter 1* and "parameter 2" and *parameter 3*'

      world = CukeModeler::World
      world.left_delimiter = '"'
      world.right_delimiter = '"'

      step = clazz.new(source)

      step.arguments.should == ['parameter 2']
    end

    it 'finds nothing when no regular expression or delimiters are available' do
      world = CukeModeler::World
      world.left_delimiter = nil
      world.right_delimiter = nil

      source = 'Given a test step with *parameter 1* and "parameter 2" and *parameter 3*'
      step = clazz.new(source)

      step.scan_arguments

      step.arguments.should == []
    end

    it 'can determine its equality with another Step' do
      source_1 = "Given a test step with *parameter 1* and *parameter 2*\n|a block|"
      source_2 = "Given a test step with *parameter 3* and *parameter 4*\n|another block|"
      source_3 = 'Given a different *parameterized* step'

      step_1 = clazz.new(source_1)
      step_2 = clazz.new(source_2)
      step_3 = clazz.new(source_3)

      step_1.delimiter = '*'
      step_2.delimiter = '*'
      step_3.delimiter = '*'


      (step_1 == step_2).should be_true
      (step_1 == step_3).should be_false
    end

    describe '#step_text' do

      let(:source) { "Given a test step with -parameter 1- ^and@ *parameter 2!!\n|a block|" }
      let(:step) { clazz.new(source) }


      it 'returns the step\'s entire text by default' do
        source = "Given a test step with -parameter 1- ^and@ *parameter 2!!\n|a block|"
        step_with_block = clazz.new(source)

        expected_output = ['Given a test step with -parameter 1- ^and@ *parameter 2!!',
                           '|a block|']

        step_with_block.step_text.should == expected_output

        source = 'Given a test step with -parameter 1- ^and@ *parameter 2!!'
        step_without_block = clazz.new(source)

        expected_output = ['Given a test step with -parameter 1- ^and@ *parameter 2!!']

        step_without_block.step_text.should == expected_output
      end

      it 'can provide the step\'s text without the keyword' do
        expected_output = ['a test step with -parameter 1- ^and@ *parameter 2!!',
                           '|a block|']

        step.step_text(:with_keywords => false).should == expected_output
      end

    end

    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario: Test test',
                  '    * a step:']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/step_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:step) { directory.feature_files.first.features.first.tests.first.steps.first }


      it 'can get its directory' do
        ancestor = step.get_ancestor(:directory)

        ancestor.should equal directory
      end

      it 'can get its feature file' do
        ancestor = step.get_ancestor(:feature_file)

        ancestor.should equal directory.feature_files.first
      end

      it 'can get its feature' do
        ancestor = step.get_ancestor(:feature)

        ancestor.should equal directory.feature_files.first.features.first
      end

      it 'can get its test' do
        ancestor = step.get_ancestor(:test)

        ancestor.should equal directory.feature_files.first.features.first.tests.first
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = step.get_ancestor(:example)

        ancestor.should be_nil
      end

    end

    describe 'step output edge cases' do

      context 'a new step object' do

        let(:step) { clazz.new }


        it 'can output a step that has only a table' do
          step.block = CukeModeler::Table.new

          expect { step.to_s }.to_not raise_error
        end

        it 'can output a step that has only a doc string' do
          step.block = CukeModeler::DocString.new

          expect { step.to_s }.to_not raise_error
        end

      end

    end

  end

end
