require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Integration' do

  clazz = CukeModeler::Feature

  before(:each) do
    @feature = clazz.new
  end

  it 'properly sets its child elements' do
    source = ['@a_tag',
              'Feature: Test feature',
              '  Background: Test background',
              '  Scenario: Test scenario',
              '  Scenario Outline: Test outline',
              '  Examples: Test Examples',
              '    | param |',
              '    | value |']
    source = source.join("\n")


    feature = CukeModeler::Feature.new(source)
    background = feature.background
    scenario = feature.tests[0]
    outline = feature.tests[1]
    tag = feature.tag_elements[0]


    outline.parent_element.should equal feature
    scenario.parent_element.should equal feature
    background.parent_element.should equal feature
    tag.parent_element.should equal feature
  end

  it 'can distinguish scenarios from outlines - #scenarios, #outlines' do
    scenarios = [CukeModeler::Scenario.new('Scenario: 1'), CukeModeler::Scenario.new('Scenario: 2')]
    outlines = [CukeModeler::Outline.new("Scenario Outline: 1\nExamples:\n|param|\n|value|"), CukeModeler::Outline.new("Scenario Outline: 2\nExamples:\n|param|\n|value|")]

    @feature.tests = scenarios + outlines

    @feature.scenarios.should =~ scenarios
    @feature.outlines.should =~ outlines
  end

  it 'knows how many scenarios it has - #scenario_count' do
    scenarios = [CukeModeler::Scenario.new('Scenario: 1'), CukeModeler::Scenario.new('Scenario: 2')]
    outlines = [CukeModeler::Outline.new("Scenario Outline: 1\nExamples:\n|param|\n|value|")]

    @feature.tests = []
    @feature.scenario_count.should == 0

    @feature.tests = scenarios + outlines
    @feature.scenario_count.should == 2
  end

  it 'knows how many outlines it has - #outline_count' do
    scenarios = [CukeModeler::Scenario.new('Scenario: 1')]
    outlines = [CukeModeler::Outline.new("Scenario Outline: 1\nExamples:\n|param|\n|value|"), CukeModeler::Outline.new("Scenario Outline: 2\nExamples:\n|param|\n|value|")]

    @feature.tests = []
    @feature.outline_count.should == 0

    @feature.tests = scenarios + outlines
    @feature.outline_count.should == 2
  end

  it 'knows how many test cases it has - #test_case_count' do
    source_1 = ['Feature: Test feature']
    source_1 = source_1.join("\n")

    source_2 = ['Feature: Test feature',
                '  Scenario: Test scenario',
                '  Scenario Outline: Test outline',
                '    * a step',
                '  Examples: Test examples',
                '    |param|',
                '    |value_1|',
                '    |value_2|']
    source_2 = source_2.join("\n")

    feature_1 = CukeModeler::Feature.new(source_1)
    feature_2 = CukeModeler::Feature.new(source_2)


    feature_1.test_case_count.should == 0
    feature_2.test_case_count.should == 3
  end


  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/feature_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @feature = @directory.feature_files.first.features.first
    end


    it 'can get its directory' do
      directory = @feature.get_ancestor(:directory)

      directory.should equal @directory
    end

    it 'can get its feature file' do
      feature_file = @feature.get_ancestor(:feature_file)

      feature_file.should equal @directory.feature_files.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      test = @feature.get_ancestor(:test)

      test.should be_nil
    end

  end

  context 'feature output edge cases' do

    it 'can output a feature that has only a tag elements' do
      @feature.tag_elements = [CukeModeler::Tag.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only a background' do
      @feature.background = [CukeModeler::Background.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only scenarios' do
      @feature.tests = [CukeModeler::Scenario.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only outlines' do
      @feature.tests = [CukeModeler::Outline.new]

      expect { @feature.to_s }.to_not raise_error
    end

  end

end
