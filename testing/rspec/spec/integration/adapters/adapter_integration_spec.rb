require "#{File.dirname(__FILE__)}/../../spec_helper"


describe "Gherkin#{gherkin_major_version}Adapter, Integration" do

  let(:clazz) { CukeModeler.const_get("Gherkin#{gherkin_major_version}Adapter") }
  let(:adapter) { clazz.new }

  describe 'parsing data' do

    let(:source_text) do
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
       #{RULE_KEYWORD}: a rule

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


       #{RULE_KEYWORD}: another rule

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

    it "does not store parsing data for an example's children" do
      model = feature_model.rules.first.outlines.first.examples.first

      expect(model.parsing_data[:tags]).to be_nil
      expect(model.parsing_data[:table_header]).to be_nil
      expect(model.parsing_data[:table_body]).to be_nil
    end

    it "does not store parsing data for an example row's children" do
      model = feature_model.rules.first.outlines.first.examples.first.rows.first

      expect(model.parsing_data[:cells]).to be_nil
    end

    it "does not store parsing data for a step's children, table" do
      model = feature_model.rules.first.outlines.first.steps.first

      expect(model.parsing_data[:data_table]).to be_nil
    end

    it "does not store parsing data for a step's children, doc string" do
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

  # TODO: have these skip making a file and just use source text
  describe 'element type selection' do

    it 'correctly identifies a minimal feature' do
      source_text = "#{FEATURE_KEYWORD}:"
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)
      feature_file_model = CukeModeler::FeatureFile.new(test_file_path)

      expect(feature_file_model.feature).to be_a(CukeModeler::Feature)
    end

    it 'correctly identifies a minimal rule' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{RULE_KEYWORD}:"
      feature_model = CukeModeler::Feature.new(source_text)

      expect(feature_model.rules.first).to be_a(CukeModeler::Rule)
    end

    it 'correctly identifies a minimal background' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{BACKGROUND_KEYWORD}:"
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)
      feature_file_model = CukeModeler::FeatureFile.new(test_file_path)

      expect(feature_file_model.feature.background).to be_a(CukeModeler::Background)
    end

    it 'correctly identifies a minimal scenario' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{SCENARIO_KEYWORD}:"
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)
      feature_file_model = CukeModeler::FeatureFile.new(test_file_path)

      expect(feature_file_model.feature.tests.first).to be_a(CukeModeler::Scenario)
    end

    it 'correctly identifies a minimal outline' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{OUTLINE_KEYWORD}:"
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)
      feature_file_model = CukeModeler::FeatureFile.new(test_file_path)

      expect(feature_file_model.feature.tests.first).to be_a(CukeModeler::Outline)
    end

    it 'correctly identifies a minimal example' do
      source_text = "#{FEATURE_KEYWORD}:
                       #{OUTLINE_KEYWORD}:
                       #{EXAMPLE_KEYWORD}:"
      test_file_path = CukeModeler::FileHelper.create_feature_file(text: source_text)
      feature_file_model = CukeModeler::FeatureFile.new(test_file_path)

      expect(feature_file_model.feature.tests.first.examples.first).to be_a(CukeModeler::Example)
    end

  end

  describe 'stuff that is in no way part of the public API and entirely subject to change' do

    it 'provides a useful explosion message if it encounters an entirely new type of test' do
      partial_feature_ast = { type: :Feature, location: { line: 1, column: 1 }, children: [{ some_unknown_type: {} }] }

      expect { adapter.adapt_feature!(partial_feature_ast) }.to raise_error(ArgumentError, /Unknown.*some_unknown_type/)
    end

  end

end
