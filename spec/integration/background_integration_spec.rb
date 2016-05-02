require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Integration' do

  let(:clazz) { CukeModeler::Background }


  describe 'unique behavior' do

    it 'properly sets its child elements' do
      source = ['  Background: Test background',
                '    * a step']
      source = source.join("\n")

      background = clazz.new(source)
      step = background.steps.first

      expect(step.parent_element).to equal(background)
    end

    describe 'getting ancestors' do

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
        ancestor = background.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = background.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = background.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.features.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = background.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end

    describe 'background output edge cases' do

      context 'a new background object' do

        let(:background) { clazz.new }


        it 'can output a background that has only steps' do
          background.steps = [CukeModeler::Step.new]

          expect { background.to_s }.to_not raise_error
        end

      end

    end

  end

end
