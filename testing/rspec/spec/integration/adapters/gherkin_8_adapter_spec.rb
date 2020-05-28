require "#{File.dirname(__FILE__)}/../../spec_helper"


describe 'Gherkin8Adapter, Integration', :if => gherkin?(8) do

  let(:clazz) { CukeModeler::Gherkin8Adapter }
  let(:adapter) { clazz.new }
  let(:source_text) { "# feature comment
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
                       # final comment" }
  let(:feature_file_model) do
    test_file_path = CukeModeler::FileHelper.create_feature_file(:text => source_text, :name => 'adapter_test_file')

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
    model = feature_model.outlines.first

    expect(model.parsing_data[:scenario][:tags]).to be_nil
    expect(model.parsing_data[:scenario][:steps]).to be_nil
    expect(model.parsing_data[:scenario][:examples]).to be_nil
  end

  it "does not store parsing data for an example's children" do
    model = feature_model.outlines.first.examples.first

    expect(model.parsing_data[:tags]).to be_nil
    expect(model.parsing_data[:table_header]).to be_nil
    expect(model.parsing_data[:table_body]).to be_nil
  end

  it "does not store parsing data for an example row's children" do
    model = feature_model.outlines.first.examples.first.rows.first

    expect(model.parsing_data[:cells]).to be_nil
  end

  it "does not store parsing data for a step's children, table" do
    model = feature_model.outlines.first.steps.first

    expect(model.parsing_data[:data_table]).to be_nil
  end

  it "does not store parsing data for a step's children, doc string" do
    model = feature_model.outlines.first.steps.last

    expect(model.parsing_data[:doc_string]).to be_nil
  end

  it "does not store parsing data for a table's children" do
    model = feature_model.outlines.first.steps.first.block

    expect(model.parsing_data[:rows]).to be_nil
  end

  it "does not store parsing data for a table row's children" do
    model = feature_model.outlines.first.steps.first.block.rows.first

    expect(model.parsing_data[:cells]).to be_nil
  end


  describe 'stuff that is in no way part of the public API and entirely subject to change' do

    it 'provides a useful explosion message if it encounters an entirely new type of test' do
      partial_feature_ast = { :type => :Feature, :location => { :line => 1, :column => 1 }, :children => [{ :some_unknown_type => {} }] }

      expect { adapter.adapt_feature!(partial_feature_ast) }.to raise_error(ArgumentError, /Unknown.*some_unknown_type/)
    end

  end

end
