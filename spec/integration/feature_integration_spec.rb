require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Integration' do

  clazz = CukeModeler::Feature

  before(:each) do
    @feature = clazz.new
  end

  it 'properly sets its child elements' do
    source = "@a_tag
              Feature: Test feature
                Background: Test background
                Scenario: Test scenario
                Scenario Outline: Test outline"


    feature = clazz.new(source)
    background = feature.background
    scenario = feature.tests[0]
    outline = feature.tests[1]
    tag = feature.tags[0]


    outline.parent_element.should equal feature
    scenario.parent_element.should equal feature
    background.parent_element.should equal feature
    tag.parent_element.should equal feature
  end

  it 'can selectively access its scenarios and outlines' do
    @feature.should respond_to(:scenarios)
    @feature.should respond_to(:outlines)

    scenarios = [CukeModeler::Scenario.new, CukeModeler::Scenario.new]
    outlines = [CukeModeler::Outline.new, CukeModeler::Outline.new]

    @feature.tests = scenarios + outlines

    @feature.scenarios.should =~ scenarios
    @feature.outlines.should =~ outlines
  end

  describe 'getting ancestors' do

    before(:each) do
      source = ['Feature: Test feature']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/feature_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @feature = @directory.feature_files.first.feature
    end


    it 'can get its directory' do
      ancestor = @feature.get_ancestor(:directory)

      ancestor.should equal @directory
    end

    it 'can get its feature file' do
      ancestor = @feature.get_ancestor(:feature_file)

      ancestor.should equal @directory.feature_files.first
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = clazz.new.get_ancestor(:directory)

      ancestor.should be_nil
    end

  end

  describe 'feature output edge cases' do

    it 'can output a feature that has only a tags' do
      @feature.tags = [CukeModeler::Tag.new]

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
