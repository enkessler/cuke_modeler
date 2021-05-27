require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Adapter, Integration' do

  let(:clazz) { CukeModeler.const_get("Gherkin#{gherkin_major_version}Adapter") }
  let(:adapter) { clazz.new }

  describe 'parsing data' do

    # Rules became taggable in Gherkin 18
    let(:gherkin_versions_with_untagged_rules) { (9..17) }

    # Essentially, maximum viable Gherkin of any significance that can be in a feature file
    let(:source_text) do
      tag_text = gherkin?(gherkin_versions_with_untagged_rules) ? '' : "@tag1 @tag2 @tag3\n"

      "# feature comment
       @tag1 @tag2 @tag3
       #{FEATURE_KEYWORD}: A feature with everything it could have

       Including a description
       and then some.

         # background comment
         #{BACKGROUND_KEYWORD}: non-nested background

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
         #{SCENARIO_KEYWORD}: non-nested scenario

         Scenario
         description

           #{STEP_KEYWORD} a step
           #{STEP_KEYWORD} another step
             \"\"\" with content type
             some text
             \"\"\"

       # rule comment
       #{tag_text}#{RULE_KEYWORD}: A rule

         Rule description

         #{BACKGROUND_KEYWORD}: nested background
           #{STEP_KEYWORD} a step

           # outline comment
           @outline_tag
           #{OUTLINE_KEYWORD}: nested outline

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
           #{EXAMPLE_KEYWORD}: additional example


       #{tag_text}#{RULE_KEYWORD}: another rule

       Which is empty

       # final comment"
    end

    let(:feature_file_model) do
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text, name: 'adapter_test_file')

      CukeModeler::FeatureFile.new(test_file_path)
    end
    let(:feature_model) { feature_file_model.feature }


    it "does not store parsing data for a feature file's children" do
      model = feature_file_model

      expect(model.parsing_data[:comments]).to be_nil
      expect(model.parsing_data[:feature]).to be_nil
    end

    it "does not store parsing data for a feature's children" do
      model = feature_model

      expect(model.parsing_data[:tags]).to be_nil
      expect(model.parsing_data[:children]).to be_nil
    end

    it "does not store parsing data for a rule's children" do
      model = feature_model.rules.first

      expect(model.parsing_data[:rule][:tags]).to be_nil # This will be nil for <18.x anyway
      expect(model.parsing_data[:rule][:children]).to be_nil
    end

    it "does not store parsing data for a background's children" do
      model = feature_model.background

      expect(model.parsing_data[:background][:steps]).to be_nil
    end

    it "does not store parsing data for a scenario's children" do
      model = feature_model.scenarios.first

      expect(model.parsing_data[:scenario][:tags]).to be_nil
      expect(model.parsing_data[:scenario][:steps]).to be_nil
    end

    it "does not store parsing data for an outline's children" do
      model = feature_model.rules.first.outlines.first

      expect(model.parsing_data[:scenario][:tags]).to be_nil
      expect(model.parsing_data[:scenario][:steps]).to be_nil
      expect(model.parsing_data[:scenario][:examples]).to be_nil
    end

    it "does not store parsing data for an example's children", if: gherkin?(19) do
      model = feature_model.rules.first.outlines.first.examples.first

      expect(model.parsing_data[:tags]).to be_nil
      expect(model.parsing_data[:tableHeader]).to be_nil
      expect(model.parsing_data[:tableBody]).to be_nil
    end

    it "does not store parsing data for an example's children", if: gherkin?((9..18)) do
      model = feature_model.rules.first.outlines.first.examples.first

      expect(model.parsing_data[:tags]).to be_nil
      expect(model.parsing_data[:table_header]).to be_nil
      expect(model.parsing_data[:table_body]).to be_nil
    end

    it "does not store parsing data for an example row's children" do
      model = feature_model.rules.first.outlines.first.examples.first.rows.first

      expect(model.parsing_data[:cells]).to be_nil
    end

    it "does not store parsing data for a step's children, table", if: gherkin?(19) do
      model = feature_model.rules.first.outlines.first.steps.first

      expect(model.parsing_data[:dataTable]).to be_nil
    end

    it "does not store parsing data for a step's children, table", if: gherkin?((9..18)) do
      model = feature_model.rules.first.outlines.first.steps.first

      expect(model.parsing_data[:data_table]).to be_nil
    end


    it "does not store parsing data for a step's children, doc string", if: gherkin?(19) do
      model = feature_model.rules.first.outlines.first.steps.last

      expect(model.parsing_data[:docString]).to be_nil
    end

    it "does not store parsing data for a step's children, doc string", if: gherkin?((9..18)) do
      model = feature_model.rules.first.outlines.first.steps.last

      expect(model.parsing_data[:doc_string]).to be_nil
    end

    it "does not store parsing data for a table's children" do
      model = feature_model.rules.first.outlines.first.steps.first.block

      expect(model.parsing_data[:rows]).to be_nil
    end

    it "does not store parsing data for a table row's children" do
      model = feature_model.rules.first.outlines.first.steps.first.block.rows.first

      expect(model.parsing_data[:cells]).to be_nil
    end

  end

  describe 'element type selection' do

    it 'correctly identifies a minimal feature' do
      source_text = "#{FEATURE_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']).to_not be_nil
    end

    it 'correctly identifies a minimal rule' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{RULE_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']['elements'].first['type']).to eq('Rule')
    end

    it 'correctly identifies a minimal background' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{BACKGROUND_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']['elements'].first['type']).to eq('Background')
    end

    it 'correctly identifies a minimal scenario' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{SCENARIO_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']['elements'].first['type']).to eq('Scenario')
    end

    it 'correctly identifies a minimal outline' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{OUTLINE_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']['elements'].first['type']).to eq('ScenarioOutline')
    end

    it 'correctly identifies a minimal example' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{OUTLINE_KEYWORD}:
                       #{EXAMPLE_KEYWORD}:"
      adapted_ast = CukeModeler::Parsing.parse_text(source_text)

      expect(adapted_ast['feature']['elements'].first['examples'].count).to eq(1)
    end

  end

  describe 'stuff that is in no way part of the public API and entirely subject to change' do

    it 'provides a useful explosion message if it encounters an entirely new type of test' do
      partial_feature_ast = { type: :Feature, location: { line: 1, column: 1 }, children: [{ some_unknown_type: {} }] }

      expect { adapter.adapt_feature(partial_feature_ast) }.to raise_error(ArgumentError, /Unknown.*some_unknown_type/)
    end

  end

end
