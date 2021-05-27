require_relative '../../../../../environments/rspec_env'


RSpec.describe 'FeatureFile, Integration' do

  let(:clazz) { CukeModeler::FeatureFile }
  let(:minimum_viable_gherkin) { '' }
  let(:maximum_viable_gherkin) do
    "# feature comment
     @tag1 @tag2 @tag3
     #{FEATURE_KEYWORD}: A feature with everything it could have

     Including a description
     and then some.

       # background comment
       #{BACKGROUND_KEYWORD}:

       Background
       description

         #{STEP_KEYWORD} a step
         # table comment
           | value1 |
         # table row comment
           | value2 |
         #{STEP_KEYWORD} another step

       # scenario comment
       @scenario_tag
       #{SCENARIO_KEYWORD}:

       Scenario
       description

         #{STEP_KEYWORD} a step
         #{STEP_KEYWORD} another step
           \"\"\" with content type
           some text
           \"\"\"

       # outline comment
       @outline_tag
       #{OUTLINE_KEYWORD}:

       Outline
       description

         # step comment
         #{STEP_KEYWORD} a step
         # table comment
           | value2 |
         # step comment
         #{STEP_KEYWORD} another step
         # doc string comment
           \"\"\"
           some text
           \"\"\"

       # example comment
       @example_tag
       #{EXAMPLE_KEYWORD}:

       Example
       description

         # row comment
         | param |
         | value |
     # final comment"
  end


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end

  describe 'unique behavior' do

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?(19) do
          test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)

          feature_file = clazz.new(test_file_path)
          data = feature_file.parsing_data

          expect(data.keys).to match_array([:comments, :uri])
          expect(File.basename(data[:uri])).to eq('test_file.feature')
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?((9..18)) do
          test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)

          feature_file = clazz.new(test_file_path)
          data = feature_file.parsing_data

          expect(data.keys).to match_array([:uri])
          expect(File.basename(data[:uri])).to eq('test_file.feature')
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter' do
          test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)

          feature_file = clazz.new(test_file_path)
          data = feature_file.parsing_data

          expect(data.keys).to match_array([:uri, :feature, :comments])
          expect(File.basename(data[:uri])).to eq('test_file.feature')
        end

      end

    end

    it 'provides its own filename when being parsed' do
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: 'bad feature text', name: 'test_file')

      expect { clazz.new(test_file_path) }.to raise_error(/'#{test_file_path}'/)
    end

    it 'cannot model a non-existent feature file' do
      path = "#{CukeModeler::FileHelper.create_directory}/missing_file.feature"

      expect { clazz.new(path) }.to raise_error(ArgumentError)
    end


    describe 'model population' do

      let(:source_text) { "#{FEATURE_KEYWORD}: Test feature" }
      let(:feature_file_path) { CukeModeler::FileHelper.create_feature_file }
      let(:feature_file) { clazz.new(feature_file_path) }

      before(:each) do
        File.open(feature_file_path, 'w') { |file| file.write(source_text) }
      end

      it "models the feature file's name" do
        expect(feature_file.name).to eq(File.basename(feature_file_path))
      end

      it "models the feature file's path" do
        expect(feature_file.path).to eq(feature_file_path)
      end

      it "models the feature file's feature" do
        feature_name = feature_file.feature.name

        expect(feature_name).to eq('Test feature')
      end

      it "models the feature file's comments" do
        source_text = "# feature comment
                       @tag1 @tag2 @tag3
                       #{FEATURE_KEYWORD}: A feature with everything it could have

                       Including a description
                       and then some.

                         # background comment
                         #{BACKGROUND_KEYWORD}:

                         Background
                         description

                           #{STEP_KEYWORD} a step
                           # table comment
                             | value1 |
                             # table row comment
                             | value2 |
                           #{STEP_KEYWORD} another step

                         # scenario comment
                         @scenario_tag
                         #{SCENARIO_KEYWORD}:

                         Scenario
                         description

                         #{STEP_KEYWORD} a step
                         #{STEP_KEYWORD} another step
                           \"\"\"
                           some text
                           \"\"\"

                         # outline comment
                         @outline_tag
                         #{OUTLINE_KEYWORD}:

                         Outline
                         description

                           # step comment
                           #{STEP_KEYWORD} a step
                           # table comment
                             | value2 |
                           # step comment
                           #{STEP_KEYWORD} another step
                             # doc string comment
                             \"\"\"
                             some text
                             \"\"\"

                         # example comment
                         @example_tag
                         #{EXAMPLE_KEYWORD}:

                         Example
                         description

                           # row comment
                           | param |
                           | value |
                       # final comment"

        File.open(feature_file_path, 'w') { |file| file.write(source_text) }

        feature_file = clazz.new(feature_file_path)
        comments = feature_file.comments.map(&:text)


        expected_comments = ['# feature comment',
                             '# background comment',
                             '# table comment',
                             '# table row comment',
                             '# scenario comment',
                             '# outline comment',
                             '# step comment',
                             '# table comment',
                             '# step comment',
                             '# doc string comment',
                             '# example comment',
                             '# row comment',
                             '# final comment']

        expect(comments).to match_array(expected_comments)
      end


      context 'an empty feature file' do

        let(:source_text) { '' }

        it "models the feature file's feature" do
          expect(feature_file.feature).to be_nil
        end

      end

    end

    it 'properly sets its child models' do
      file_path = CukeModeler::FileHelper.create_feature_file(text: "#{FEATURE_KEYWORD}: Test feature",
                                                              name: 'test_file')

      file = clazz.new(file_path)
      feature = file.feature

      expect(feature.parent_model).to equal(file)
    end


    describe 'getting ancestors' do

      let(:directory_path) { CukeModeler::FileHelper.create_directory }
      let(:feature_file_path) { CukeModeler::FileHelper.create_feature_file(text: '',
                                                                            name: 'feature_file_test_file',
                                                                            directory: directory_path) }

      before(:each) do
        File.open(feature_file_path, 'w') { |file| file.write("#{FEATURE_KEYWORD}: Test feature") }
      end

      let(:directory_model) { CukeModeler::Directory.new(directory_path) }
      let(:feature_file_model) { directory_model.feature_files.first }


      it 'can get its directory' do
        ancestor = feature_file_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = feature_file_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'feature file output' do

      context 'from source text' do

        let(:source_text) { "#{FEATURE_KEYWORD}: Test feature" }
        let(:feature_file_path) { CukeModeler::FileHelper.create_feature_file(text: '',
                                                                              name: 'feature_file_test_file') }
        let(:feature_file) { clazz.new(feature_file_path) }

        before(:each) do
          File.open(feature_file_path, 'w') { |file| file.write(source_text) }
        end


        it 'can output a feature file' do
          feature_file_output = feature_file.to_s

          expect(feature_file_output).to eq(feature_file_path)
        end

      end

      it 'can be remade from its own output' do
        path = CukeModeler::FileHelper.create_feature_file(text: "#{FEATURE_KEYWORD}:", name: 'feature_file_test_file')
        feature_file = clazz.new(path)

        feature_file_output = feature_file.to_s
        remade_feature_file_output = clazz.new(feature_file_output).to_s

        expect(remade_feature_file_output).to eq(feature_file_output)
      end

    end

  end

end
