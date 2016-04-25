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


  context 'getting stuff' do

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
      gotten_directory = scenario.get_ancestor(:directory)

      gotten_directory.should equal directory
    end

    it 'can get its feature file' do
      gotten_feature_file = scenario.get_ancestor(:feature_file)

      gotten_feature_file.should equal directory.feature_files.first
    end

    it 'can get its feature' do
      gotten_feature = scenario.get_ancestor(:feature)

      gotten_feature.should equal directory.feature_files.first.features.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_test = scenario.get_ancestor(:test)

      gotten_test.should be_nil
    end

    context 'scenario output edge cases' do

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
