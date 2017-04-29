require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Comment, Integration' do

  let(:clazz) { CukeModeler::Comment }


  describe 'common behavior' do

    it_should_behave_like 'a model, integration'

  end


  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      source = '# a comment'

      expect { clazz.new(source) }.to_not raise_error
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

    it 'stores the original data generated by the parsing adapter', :gherkin4 => true do
      comment = clazz.new('# a comment')
      data = comment.parsing_data

      expect(data.keys).to match_array([:type, :location, :text])
      expect(data[:type]).to eq(:Comment)
    end

    it 'stores the original data generated by the parsing adapter', :gherkin3 => true do
      comment = clazz.new('# a comment')
      data = comment.parsing_data

      expect(data.keys).to match_array([:type, :location, :text])
      expect(data[:type]).to eq('Comment')
    end

    it 'stores the original data generated by the parsing adapter', :gherkin2 => true do
      comment = clazz.new('# a comment')
      data = comment.parsing_data

      expect(data.keys).to match_array(['value', 'line'])
    end


    describe 'getting ancestors' do

      before(:each) do
        test_file = Tempfile.new(['comment_test_file', '.feature'], test_directory)
        File.open(test_file.path, 'w') { |file| file.write(source_gherkin) }
      end


      let(:test_directory) { Dir.mktmpdir }
      let(:source_gherkin) { "# feature comment
                              #{@feature_keyword}: Test feature"
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
          test_directory = Dir.mktmpdir
          source_text = "# a comment
                         #{@feature_keyword}:"

          test_file = Tempfile.new(['comment_test_file', '.feature'], test_directory)
          File.open(test_file.path, 'w') { |file| file.write(source_text) }
          comment = CukeModeler::FeatureFile.new(test_file.path).comments.first

          expect(comment.source_line).to eq(1)
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
