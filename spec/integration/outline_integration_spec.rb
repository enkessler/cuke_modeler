require 'spec_helper'

SimpleCov.command_name('Outline') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Outline, Integration' do

  let(:clazz) { CukeModeler::Outline }


  describe 'unique behavior' do

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

      expect(example.parent_element).to equal(outline)
      expect(step.parent_element).to equal(outline)
      expect(tag.parent_element).to equal(outline)
    end


    describe 'getting ancestors' do

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
        ancestor = outline.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = outline.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = outline.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.features.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = outline.get_ancestor(:test)

        expect(ancestor).to be_nil
      end

      describe 'outline output edge cases' do

        context 'a new outline object' do

          let(:outline) { clazz.new }


          it 'can output an outline that has only tag elements' do
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

  end

end
