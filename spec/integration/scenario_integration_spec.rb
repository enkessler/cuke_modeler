require 'spec_helper'

SimpleCov.command_name('Scenario') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Scenario, Integration' do

  let(:clazz) { CukeModeler::Scenario }


  it 'properly sets its child elements' do
    source = ['@a_tag',
              'Scenario: Test scenario',
              '  * a step']
    source = source.join("\n")

    scenario = clazz.new(source)
    step = scenario.steps.first
    tag = scenario.tag_elements.first

    step.parent_element.should equal scenario
    tag.parent_element.should equal scenario
  end


  describe 'getting ancestors' do

    before(:each) do
      source = ['Feature: Test feature',
                '',
                '  Scenario: Test test',
                '    * a step']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/scenario_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:scenario) { directory.feature_files.first.features.first.tests.first }


    it 'can get its directory' do
      ancestor = scenario.get_ancestor(:directory)

      ancestor.should equal directory
    end

    it 'can get its feature file' do
      ancestor = scenario.get_ancestor(:feature_file)

      ancestor.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      ancestor = scenario.get_ancestor(:feature)

      ancestor.should equal directory.feature_files.first.features.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = scenario.get_ancestor(:test)

      ancestor.should be_nil
    end

    describe 'scenario output edge cases' do

      it 'can output a scenario that has only a tag elements' do
        scenario.tag_elements = [CukeModeler::Tag.new]

        expect { scenario.to_s }.to_not raise_error
      end

      it 'can output a scenario that has only steps' do
        scenario.steps = [CukeModeler::Step.new]

        expect { scenario.to_s }.to_not raise_error
      end

    end

  end
end
