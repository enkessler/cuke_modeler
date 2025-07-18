require_relative '../../../../../environments/rspec_env'


RSpec.describe 'DocString, Integration' do

  let(:clazz) { CukeModeler::DocString }
  let(:minimum_viable_gherkin) { "\"\"\"\n\"\"\"" }
  let(:maximum_viable_gherkin) do
    ['""" type foo',
     '\"\"\"',
     'bar',
     '\"\"\"',
     '"""'].join("\n")
  end
  let(:maximal_string_input) { maximum_viable_gherkin }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end

  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      expect { clazz.new(minimum_viable_gherkin) }.to_not raise_error
    end

    it 'can parse text that uses a non-default dialect' do
      original_dialect = CukeModeler::Parsing.dialect
      CukeModeler::Parsing.dialect = 'en-au'

      begin
        source_text = "\"\"\"\ntext foo\n\"\"\""

        expect { @model = clazz.new(source_text) }.to_not raise_error

        # Sanity check in case modeling failed in a non-explosive manner
        expect(@model.content).to eq('text foo')
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        CukeModeler::Parsing.dialect = original_dialect
      end
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = 'bad doc string text'

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_doc_string\.feature'/)
    end

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?(20..MOST_CURRENT_GHERKIN_VERSION) do # rubocop:disable Layout/LineLength
          doc_string = clazz.new(source_text)
          data = doc_string.parsing_data

          expect(data).to be_a(Cucumber::Messages::DocString)
          expect(data.delimiter).to eq('"""')
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?(9..19) do
          doc_string = clazz.new(source_text)
          data = doc_string.parsing_data

          expect(data.keys).to match_array([:location, :content, :delimiter])
          expect(data[:delimiter]).to eq('"""')
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?(20..MOST_CURRENT_GHERKIN_VERSION) do # rubocop:disable Layout/LineLength
          doc_string = clazz.new(source_text)
          data = doc_string.parsing_data

          expect(data).to be_a(Cucumber::Messages::DocString)
          expect(data.content).to eq("\"\"\"\nbar\n\"\"\"")
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?(19) do
          doc_string = clazz.new(source_text)
          data = doc_string.parsing_data

          expect(data.keys).to match_array([:location, :content, :mediaType, :delimiter])
          expect(data[:content]).to eq("\"\"\"\nbar\n\"\"\"")
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?(9..18) do
          doc_string = clazz.new(source_text)
          data = doc_string.parsing_data

          expect(data.keys).to match_array([:location, :content, :media_type, :delimiter])
          expect(data[:content]).to eq("\"\"\"\nbar\n\"\"\"")
        end

      end

    end

    it 'stores its content as a String' do
      source = "\"\"\"\nsome text\nsome more text\n\"\"\""
      doc_string = clazz.new(source)

      content = doc_string.content

      expect(content).to be_a(String)
    end


    describe 'getting ancestors' do

      before(:each) do
        CukeModeler::FileHelper.create_feature_file(text: source_gherkin,
                                                    name: 'doc_string_test_file',
                                                    directory: test_directory)
      end


      let(:test_directory) { CukeModeler::FileHelper.create_directory }
      let(:source_gherkin) {
        "#{FEATURE_KEYWORD}: Test feature

           #{SCENARIO_KEYWORD}: Test test
             #{STEP_KEYWORD} a big step:
             \"\"\"
             a
             doc
             string
             \"\"\""
      }

      let(:directory_model) { CukeModeler::Directory.new(test_directory) }
      let(:doc_string_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block }


      it 'can get its directory' do
        ancestor = doc_string_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'can get its feature file' do
        ancestor = doc_string_model.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory_model.feature_files.first)
      end

      it 'can get its feature' do
        ancestor = doc_string_model.get_ancestor(:feature)

        expect(ancestor).to equal(directory_model.feature_files.first.feature)
      end

      context 'a doc string that is part of a scenario' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{SCENARIO_KEYWORD}: Test test
               #{STEP_KEYWORD} a big step:
                 \"\"\"
                 a
                 doc
                 string
                 \"\"\""
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:doc_string_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block }


        it 'can get its scenario' do
          ancestor = doc_string_model.get_ancestor(:scenario)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first)
        end

      end

      context 'a doc string that is part of an outline' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{OUTLINE_KEYWORD}: Test outline
               #{STEP_KEYWORD} a big step:
                 \"\"\"
                 a
                 doc
                 string
                 \"\"\"
             #{EXAMPLE_KEYWORD}:
               | param |
               | value |"
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:doc_string_model) { directory_model.feature_files.first.feature.tests.first.steps.first.block }


        it 'can get its outline' do
          ancestor = doc_string_model.get_ancestor(:outline)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first)
        end

      end

      context 'a doc string that is part of a background' do

        let(:test_directory) { CukeModeler::FileHelper.create_directory }
        let(:source_gherkin) {
          "#{FEATURE_KEYWORD}: Test feature

             #{BACKGROUND_KEYWORD}: Test background
               #{STEP_KEYWORD} a big step:
                 \"\"\"
                 a
                 doc
                 string
                 \"\"\""
        }

        let(:directory_model) { CukeModeler::Directory.new(test_directory) }
        let(:doc_string_model) { directory_model.feature_files.first.feature.background.steps.first.block }


        it 'can get its background' do
          ancestor = doc_string_model.get_ancestor(:background)

          expect(ancestor).to equal(directory_model.feature_files.first.feature.background)
        end

      end

      it 'can get its step' do
        ancestor = doc_string_model.get_ancestor(:step)

        expect(ancestor).to equal(directory_model.feature_files.first.feature.tests.first.steps.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = doc_string_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        context 'a filled doc string' do

          let(:source_text) {
            ['""" type foo',
             'bar',
             '"""'].join("\n")
          }
          let(:doc_string) { clazz.new(source_text) }


          it "models the doc string's content type" do
            expect(doc_string.content_type).to eq('type foo')
          end

          it "models the doc_string's content" do
            expect(doc_string.content).to eq('bar')
          end

        end

        context 'an empty doc_string' do

          let(:source_text) {
            '"""
             """'
          }
          let(:doc_string) { clazz.new(source_text) }

          it "models the doc_string's content type" do
            expect(doc_string.content_type).to be_nil
          end

          it "models the doc_string's content" do
            expect(doc_string.content).to eq('')
          end

        end

        it "models the doc string's source line" do
          source_text = <<~TEXT
            #{FEATURE_KEYWORD}:

               #{SCENARIO_KEYWORD}:
                 #{STEP_KEYWORD} step
                   """
                   foo
                   """
          TEXT
          doc_string = CukeModeler::Feature.new(source_text).tests.first.steps.first.block

          expect(doc_string.source_line).to eq(5)
        end

        it "models the doc string's source column" do
          source_text = <<~TEXT
            #{FEATURE_KEYWORD}:

               #{SCENARIO_KEYWORD}:
                 #{STEP_KEYWORD} step
                   """
                   foo
                   """
          TEXT
          doc_string = CukeModeler::Feature.new(source_text).tests.first.steps.first.block

          expect(doc_string.source_column).to eq(8)
        end
      end

    end


    describe 'doc string output' do

      describe 'stringification' do

        context 'from source text' do

          # The minimal doc string case
          it 'can stringify an empty doc string' do
            source = ['"""',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""', '"""'])
          end

          it 'can stringify a doc string that has a content type' do
            source = ['""" foo',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['""" foo',
                                             '"""'])
          end

          it 'can stringify a doc_string that has contents' do
            source = ['"""',
                      'foo',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""',
                                             'foo',
                                             '"""'])
          end

          #  Since triple double quotes mark the beginning and end of a doc string, any triple
          #  double quotes inside of the doc string (which would have had to have been escaped
          #  to get inside in the first place) will be escaped when outputted so as to
          #  retain the quality of being able to use the output directly as gherkin.

          it 'can stringify a doc_string that has triple double quotes in the contents' do
            source = ['"""',
                      'a \"\"\"',
                      '\"\"\" again',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""',
                                             'a \"\"\"',
                                             '\"\"\" again',
                                             '"""'])
          end

          # Double quotes that are not three (or more) in a row do not seem to need and special escaping when
          # used in Gherkin. Therefore they should be left alone.
          it 'only escapes triple double quotes' do
            source = ['"""',
                      'change these \"\"\"\"\"\"',
                      'but leave " and "" alone',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""',
                                             'change these \"\"\"\"\"\"',
                                             'but leave " and "" alone',
                                             '"""'])
          end

          # The maximal doc string case
          it 'can stringify a doc string that has everything' do
            source = ['""" type foo',
                      '\"\"\"',
                      'bar',
                      '\"\"\"',
                      '"""']
            source = source.join("\n")
            doc_string = clazz.new(source)

            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['""" type foo',
                                             '\"\"\"',
                                             'bar',
                                             '\"\"\"',
                                             '"""'])
          end

        end

      end

    end

  end

end
