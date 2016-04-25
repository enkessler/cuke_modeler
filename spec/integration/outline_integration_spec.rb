require 'spec_helper'

SimpleCov.command_name('Outline') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Outline, Integration' do

  let(:clazz) { CukeModeler::Outline }


  it 'properly sets its child elements' do
    source = ['@a_tag',
              '  Scenario Outline:',
              '    * a step',
              '  Examples:',
              '    | param |',
              '    | value |']
    source = source.join("\n")

    outline = clazz.new(source)
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
                '    | a param |',
                '    | a value |']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/outline_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:outline) { directory.feature_files.first.features.first.tests.first }


    it 'can get its directory' do
      gotten_directory = outline.get_ancestor(:directory)

      gotten_directory.should equal directory
    end

    it 'can get its feature file' do
      gotten_feature_file = outline.get_ancestor(:feature_file)

      gotten_feature_file.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      gotten_feature = outline.get_ancestor(:feature)

      gotten_feature.should equal directory.feature_files.first.features.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_test = outline.get_ancestor(:test)

      gotten_test.should be_nil
    end

    context 'outline output edge cases' do

      it 'can output an outline that has only a tag elements' do
        outline.tag_elements = [CukeModeler::Tag.new]

        expect { outline.to_s }.to_not raise_error
      end

      it 'can output an outline that has only steps' do
        outline.steps = [CukeModeler::Step.new]

        expect { outline.to_s }.to_not raise_error
      end

      it 'can output an outline that has only examples' do
        outline.examples = [CukeModeler::Example.new]

        expect { outline.to_s }.to_not raise_error
      end

    end

  end
end
