require 'spec_helper'

SimpleCov.command_name('Outline') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Outline, Integration' do

  it 'properly sets its child elements' do
    source = ['@a_tag',
              '  Scenario Outline:',
              '    * a step',
              '  Examples:',
              '    | param |']
    source = source.join("\n")

    outline = CukeModeler::Outline.new(source)
    example = outline.examples.first
    step = outline.steps.first
    tag = outline.tag_elements.first

    example.parent_element.should equal outline
    step.parent_element.should equal outline
    tag.parent_element.should equal outline
  end


  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature',
                '',
                '  Scenario Outline: Test test',
                '    * a step',
                '  Examples: Test example',
                '    | a param |']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/outline_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @outline = @directory.feature_files.first.features.first.tests.first
    end


    it 'can get its directory' do
      directory = @outline.get_ancestor(:directory)

      directory.should equal @directory
    end

    it 'can get its feature file' do
      feature_file = @outline.get_ancestor(:feature_file)

      feature_file.should equal @directory.feature_files.first
    end

    it 'can get its feature' do
      feature = @outline.get_ancestor(:feature)

      feature.should equal @directory.feature_files.first.features.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      test = @outline.get_ancestor(:test)

      test.should be_nil
    end

    context 'outline output edge cases' do

      it 'can output an outline that has only a tag elements' do
        @outline.tag_elements = [CukeModeler::Tag.new]

        expect { @outline.to_s }.to_not raise_error
      end

      it 'can output an outline that has only steps' do
        @outline.steps = [CukeModeler::Step.new]

        expect { @outline.to_s }.to_not raise_error
      end

      it 'can output an outline that has only examples' do
        @outline.examples = [CukeModeler::Example.new]

        expect { @outline.to_s }.to_not raise_error
      end

    end

  end
end
