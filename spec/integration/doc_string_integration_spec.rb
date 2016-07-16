require 'spec_helper'

SimpleCov.command_name('DocString') unless RUBY_VERSION.to_s < '1.9.0'

describe 'DocString, Integration' do

  let(:clazz) { CukeModeler::DocString }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element, integration'

  end

  describe 'unique behavior' do

    describe 'getting ancestors' do

      before(:each) do
        source = ['Feature: Test feature',
                  '',
                  '  Scenario: Test test',
                  '    * a big step:',
                  '  """',
                  '  a',
                  '  doc',
                  '  string',
                  '  """']
        source = source.join("\n")

        file_path = "#{@default_file_directory}/doc_string_test_file.feature"
        File.open(file_path, 'w') { |file| file.write(source) }
      end

      let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
      let(:doc_string) { directory.feature_files.first.feature.tests.first.steps.first.block }


      it 'can get its directory' do
        ancestor = doc_string.get_ancestor(:directory)

        expect(ancestor).to equal(directory)
      end

      it 'can get its feature file' do
        ancestor = doc_string.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = doc_string.get_ancestor(:feature)

        expect(ancestor).to equal(directory.feature_files.first.feature)
      end

      context 'a doc string that is part of a scenario' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Scenario: Test test
                        * a big step:
                          """
                          a
                          doc
                          string
                          """'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:doc_string) { directory.feature_files.first.feature.tests.first.steps.first.block }


        it 'can get its scenario' do
          ancestor = doc_string.get_ancestor(:scenario)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

      end

      context 'a doc string that is part of an outline' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Scenario Outline: Test outline
                        * a big step:
                          """
                          a
                          doc
                          string
                          """
                      Examples:
                        | param |
                        | value |'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:doc_string) { directory.feature_files.first.feature.tests.first.steps.first.block }


        it 'can get its outline' do
          ancestor = doc_string.get_ancestor(:outline)

          expect(ancestor).to equal(directory.feature_files.first.feature.tests.first)
        end

      end

      context 'a doc string that is part of a background' do

        before(:each) do
          source = 'Feature: Test feature
                    
                      Background: Test background
                        * a big step:
                          """
                          a
                          doc
                          string
                          """'

          file_path = "#{@default_file_directory}/doc_string_test_file.feature"
          File.open(file_path, 'w') { |file| file.write(source) }
        end

        let(:directory) { CukeModeler::Directory.new(@default_file_directory) }
        let(:doc_string) { directory.feature_files.first.feature.background.steps.first.block }


        it 'can get its background' do
          ancestor = doc_string.get_ancestor(:background)

          expect(ancestor).to equal(directory.feature_files.first.feature.background)
        end

      end

      it 'can get its step' do
        ancestor = doc_string.get_ancestor(:step)

        expect(ancestor).to equal(directory.feature_files.first.feature.tests.first.steps.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = doc_string.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        it "models the doc string's source line" do
          source_text = 'Feature:

                           Scenario:
                             * step
                               """
                               foo
                               """'
          doc_string = CukeModeler::Feature.new(source_text).tests.first.steps.first.block

          expect(doc_string.source_line).to eq(5)
        end

      end

    end


    describe 'doc string output' do

      it 'can be remade from its own output' do
        source = ['"""" the type',
                  '* a step',
                  '  \"\"\"',
                  '  that also has a doc string',
                  '  \"\"\"',
                  '"""']
        source = source.join("\n")
        doc_string = clazz.new(source)

        doc_string_output = doc_string.to_s
        remade_doc_string_output = clazz.new(doc_string_output).to_s

        expect(remade_doc_string_output).to eq(doc_string_output)
      end

    end

  end

end
