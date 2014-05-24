require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Integration' do

  clazz = CukeModeler::Background

  it 'properly sets its child elements' do
    source = "Background: Test background
                * a step"

    background = clazz.new(source)
    step = background.steps.first

    step.parent_element.should equal background
  end

  describe 'getting ancestors' do

    before(:each) do
      source = "Feature: Test feature

                  Background: Test background
                    * a step"

      file_path = "#{@default_file_directory}/background_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CukeModeler::Directory.new(@default_file_directory)
      @background = @directory.feature_files.first.feature.background
    end


    it 'can get its directory' do
      ancestor = @background.get_ancestor(:directory)

      ancestor.should equal @directory
    end

    it 'can get its feature file' do
      ancestor = @background.get_ancestor(:feature_file)

      ancestor.should equal @directory.feature_files.first
    end

    it 'can get its feature' do
      ancestor = @background.get_ancestor(:feature)

      ancestor.should equal @directory.feature_files.first.feature
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      ancestor = clazz.new.get_ancestor(:directory)

      ancestor.should be_nil
    end

  end

  describe 'background output edge cases' do

    before(:each) do
      @background = clazz.new
    end

    it 'can output a background that has only steps' do
      @background.steps = [CukeModeler::Step.new]

      expect { @background.to_s }.to_not raise_error
    end

  end

end
