require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Tag, Integration' do

  let(:clazz) { CukeModeler::Tag }
  let(:minimum_viable_gherkin) { '@a_tag' }
  let(:maximum_viable_gherkin) { '@a_tag' }


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
        source_text = '@foo'

        expect { @model = clazz.new(source_text) }.to_not raise_error

        # Sanity check in case modeling failed in a non-explosive manner
        expect(@model.name).to eq('@foo')
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        CukeModeler::Parsing.dialect = original_dialect
      end
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = 'bad tag text'

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_tag\.feature'/)
    end

    describe 'parsing data' do

      context 'with minimum viable Gherkin' do

        let(:source_text) { minimum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?((20..MOST_CURRENT_GHERKIN_VERSION)) do # rubocop:disable Layout/LineLength
          tag = clazz.new(source_text)
          data = tag.parsing_data

          expect(data).to be_a(Cucumber::Messages::Tag)
          expect(data.name).to eq('@a_tag')
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?((9..19)) do
          tag = clazz.new(source_text)
          data = tag.parsing_data

          expect(data.keys).to match_array([:location, :name, :id])
          expect(data[:name]).to eq('@a_tag')
        end

      end

      context 'with maximum viable Gherkin' do

        let(:source_text) { maximum_viable_gherkin }

        it 'stores the original data generated by the parsing adapter', if: gherkin?((20..MOST_CURRENT_GHERKIN_VERSION)) do # rubocop:disable Layout/LineLength
          tag = clazz.new(source_text)
          data = tag.parsing_data

          expect(data).to be_a(Cucumber::Messages::Tag)
          expect(data.name).to eq('@a_tag')
        end

        it 'stores the original data generated by the parsing adapter', if: gherkin?((9..19)) do
          tag = clazz.new(source_text)
          data = tag.parsing_data

          expect(data.keys).to match_array([:location, :name, :id])
          expect(data[:name]).to eq('@a_tag')
        end

      end

    end


    describe 'getting ancestors' do

      it 'can get its directory' do
        source_gherkin = "@feature_tag
                          #{FEATURE_KEYWORD}: Test feature"

        directory_model = CukeModeler::Directory.new(File.dirname(CukeModeler::FileHelper.create_feature_file(text: source_gherkin))) # rubocop:disable Layout/LineLength
        tag_model = directory_model.feature_files.first.feature.tags.first
        ancestor = tag_model.get_ancestor(:directory)

        expect(ancestor).to equal(directory_model)
      end

      it 'can get its feature file' do
        source_gherkin = "@feature_tag
                          #{FEATURE_KEYWORD}: Test feature"

        file_model = CukeModeler::FeatureFile.new(CukeModeler::FileHelper.create_feature_file(text: source_gherkin))
        tag_model = file_model.feature.tags.first
        ancestor = tag_model.get_ancestor(:feature_file)

        expect(ancestor).to equal(file_model)
      end

      it 'can get its feature (direct)' do
        source_gherkin = "@feature_tag
                          #{FEATURE_KEYWORD}: Test feature"

        feature_model = CukeModeler::Feature.new(source_gherkin)
        tag_model = feature_model.tags.first
        ancestor = tag_model.get_ancestor(:feature)

        expect(ancestor).to equal(feature_model)
      end

      it 'can get its feature (indirect)' do
        source_gherkin = "#{FEATURE_KEYWORD}: Test feature
                            @scenario_tag
                            #{SCENARIO_KEYWORD}: Test scenario"

        feature_model = CukeModeler::Feature.new(source_gherkin)
        tag_model = feature_model.tests.first.tags.first
        ancestor = tag_model.get_ancestor(:feature)

        expect(ancestor).to equal(feature_model)
      end

      it 'can get its rule (direct)', if: gherkin?((18..MOST_CURRENT_GHERKIN_VERSION)) do
        source_gherkin = "@rule_tag
                          #{RULE_KEYWORD}: Test rule"

        rule_model = CukeModeler::Rule.new(source_gherkin)
        tag_model = rule_model.tags.first
        ancestor = tag_model.get_ancestor(:rule)

        expect(ancestor).to equal(rule_model)
      end

      it 'can get its rule (indirect)', if: gherkin?((18..MOST_CURRENT_GHERKIN_VERSION)) do
        source_gherkin = "#{RULE_KEYWORD}: Test rule
                            @scenario_tag
                            #{SCENARIO_KEYWORD}: Test scenario"

        rule_model = CukeModeler::Rule.new(source_gherkin)
        tag_model = rule_model.tests.first.tags.first
        ancestor = tag_model.get_ancestor(:rule)

        expect(ancestor).to equal(rule_model)
      end

      it 'can get its scenario' do
        source_gherkin = "@scenario_tag
                          #{SCENARIO_KEYWORD}: Test scenario"

        scenario_model = CukeModeler::Scenario.new(source_gherkin)
        tag_model = scenario_model.tags.first
        ancestor = tag_model.get_ancestor(:scenario)

        expect(ancestor).to equal(scenario_model)
      end

      it 'can get its outline (direct)' do
        source_gherkin = "@outline_tag
                          #{OUTLINE_KEYWORD}: Test outline"

        outline_model = CukeModeler::Outline.new(source_gherkin)
        tag_model = outline_model.tags.first
        ancestor = tag_model.get_ancestor(:outline)

        expect(ancestor).to equal(outline_model)
      end

      it 'can get its outline (indirect)' do
        source_gherkin = "#{OUTLINE_KEYWORD}: Test outline
                          @example_tag
                          #{EXAMPLE_KEYWORD}: Test example"

        outline_model = CukeModeler::Outline.new(source_gherkin)
        tag_model = outline_model.examples.first.tags.first
        ancestor = tag_model.get_ancestor(:outline)

        expect(ancestor).to equal(outline_model)
      end

      it 'can get its example' do
        source_gherkin = "@example_tag
                          #{EXAMPLE_KEYWORD}: Test example"

        example_model = CukeModeler::Example.new(source_gherkin)
        tag_model = example_model.tags.first
        ancestor = tag_model.get_ancestor(:example)

        expect(ancestor).to equal(example_model)
      end

      it 'returns nil if it does not have the requested type of ancestor' do
        source_gherkin = "@feature_tag
                          #{FEATURE_KEYWORD}: Test feature"

        feature_model = CukeModeler::Feature.new(source_gherkin)
        tag_model = feature_model.tags.first
        ancestor = tag_model.get_ancestor(:example)

        expect(ancestor).to be_nil
      end

    end


    describe 'model population' do

      context 'from source text' do

        let(:source_text) { '@a_tag' }
        let(:tag) { clazz.new(source_text) }


        it "models the tag's name" do
          expect(tag.name).to eq('@a_tag')
        end

        it "models the tag's source line" do
          source_text = "#{FEATURE_KEYWORD}:

                           @a_tag
                           #{SCENARIO_KEYWORD}:
                             #{STEP_KEYWORD} step"
          tag = CukeModeler::Feature.new(source_text).tests.first.tags.first

          expect(tag.source_line).to eq(3)
        end

      end

    end


    describe 'tag output' do

      it 'can be remade from its own output' do
        source = '@some_tag'
        tag = clazz.new(source)

        tag_output = tag.to_s
        remade_tag_output = clazz.new(tag_output).to_s

        expect(remade_tag_output).to eq(tag_output)
      end


      context 'from source text' do

        it 'can output a tag' do
          source = '@a_tag'
          tag = clazz.new(source)

          expect(tag.to_s).to eq('@a_tag')
        end

      end

    end

  end

end
