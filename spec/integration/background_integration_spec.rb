require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Integration' do

  let(:clazz) { CukeModeler::Background }


  it 'properly sets its child elements' do
    source = ['  Background: Test background',
              '    * a step']
    source = source.join("\n")

    background = clazz.new(source)
    step = background.steps.first

    expect(step.parent_element).to equal(background)
  end

  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature',
                '',
                '  Background: Test background',
                '    * a step:']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/background_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }
    end

    let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
    let(:background) { directory.feature_files.first.features.first.background }


    it 'can get its directory' do
      gotten_directory = background.get_ancestor(:directory)

      expect(gotten_directory).to equal(directory)
    end

    it 'can get its feature file' do
      gotten_feature_file = background.get_ancestor(:feature_file)

      expect(gotten_feature_file).to equal(directory.feature_files.first)
    end

    it 'can get its feature' do
      gotten_feature = background.get_ancestor(:feature)

      expect(gotten_feature).to equal(directory.feature_files.first.features.first)
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      gotten_example = background.get_ancestor(:example)

      expect(gotten_example).to be_nil
    end

  end

  context 'background output edge cases' do

    it 'can output a background that has only steps' do
      background = clazz.new
      background.steps = [CukeModeler::Step.new]

      expect { background.to_s }.to_not raise_error
    end

  end

end
