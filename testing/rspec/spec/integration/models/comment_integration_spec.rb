require "#{File.dirname(__FILE__)}/../../spec_helper"


describe 'Comment, Integration' do

  let(:clazz) { CukeModeler::Comment }
  let(:minimum_viable_gherkin) { '# a comment' }
  let(:maximum_viable_gherkin) { '# a comment' }


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
        source_text = '# a comment'

        expect { @model = clazz.new(source_text) }.to_not raise_error

        # Sanity check in case modeling failed in a non-explosive manner
        expect(@model.text).to eq('# a comment')
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        CukeModeler::Parsing.dialect = original_dialect
      end
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = 'bad comment text'

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_comment\.feature'/)
    end

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter' do
          comment = clazz.new(source_text)
          data = comment.parsing_data

          expect(data.keys).to match_array([:location, :text])
          expect(data[:text]).to eq('# a comment')
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter' do
          comment = clazz.new(source_text)
          data = comment.parsing_data

          expect(data.keys).to match_array([:location, :text])
          expect(data[:text]).to eq('# a comment')
        end

      end

    end

    describe 'getting ancestors' do

      before(:each) do
        CukeModeler::FileHelper.create_feature_file(text: source_gherkin,
                                                    name: 'comment_test_file',
                                                    directory: test_directory)
      end


      let(:test_directory) { CukeModeler::FileHelper.create_directory }
      let(:source_gherkin) {
        "# feature comment
         #{FEATURE_KEYWORD}: Test feature"
      }

      let(:directory_model) { CukeModeler::Directory.new(test_directory) }
      let(:comment_model) { directory_model.feature_files.first.comments.first }


      it 'can get its directory' do
        ancestor = comment_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'can get its feature file' do
        ancestor = comment_model.get_ancestor(:feature_file)

        expect(ancestor).to equal(directory_model.feature_files.first)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        ancestor = comment_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        let(:source_text) { '# a comment' }
        let(:comment) { clazz.new(source_text) }


        it "models the comment's text" do
          expect(comment.text).to eq('# a comment')
        end

        it "models the comment's source line" do
          source_text = "# a comment
                         #{FEATURE_KEYWORD}:"

          test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text, name: 'comment_test_file')
          comment = CukeModeler::FeatureFile.new(test_file_path).comments.first

          expect(comment.source_line).to eq(1)
        end

        it "models the comment's fingerprint" do
          expect(comment.fingerprint).to eq(Digest::MD5.hexdigest(comment.to_s))
        end

        it 'removes surrounding whitespace' do
          comment = clazz.new('           # a comment             ')

          expect(comment.text).to eq('# a comment')
        end

      end

    end


    describe 'comment output' do

      it 'can be remade from its own output' do
        source = '# a comment'
        comment = clazz.new(source)

        comment_output = comment.to_s
        remade_comment_output = clazz.new(comment_output).to_s

        expect(remade_comment_output).to eq(comment_output)
      end


      context 'from source text' do

        it 'can output a comment' do
          source = '# a comment'
          comment = clazz.new(source)

          expect(comment.to_s).to eq('# a comment')
        end

      end

    end

  end

end
