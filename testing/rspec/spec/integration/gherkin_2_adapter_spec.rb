require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Gherkin2Adapter, Integration', :gherkin2 => true do

  let(:source_text) { '@tag1 @tag2 @tag3
                       Feature: A feature with everything it could have

                       Including a description
                       and then some.

                         Background:

                         Background
                         description

                           * a step
                             | value1 |
                           * another step

                         @scenario_tag
                         Scenario:

                         Scenario
                         description

                           * a step
                           * another step
                             """"
                             some text
                             """

                         @outline_tag
                         Scenario Outline:

                         Outline
                         description

                           * a step
                             | value2 |
                           * another step
                             """
                             some text
                             """

                         @example_tag
                         Examples:

                         Example
                         description

                           | param |
                           | value |' }
  let(:feature) { CukeModeler::Feature.new(source_text) }


  it "does not store parsing data for a feature's children" do
    model = feature

    expect(model.parsing_data['tags']).to be_nil
    expect(model.parsing_data['elements']).to be_nil
  end

  it "does not store parsing data for a background's children" do
    model = feature.background

    expect(model.parsing_data['steps']).to be_nil
  end

  it "does not store parsing data for a scenario's children" do
    model = feature.scenarios.first

    expect(model.parsing_data['tags']).to be_nil
    expect(model.parsing_data['steps']).to be_nil
  end

  it "does not store parsing data for an outline's children" do
    model = feature.outlines.first

    expect(model.parsing_data['tags']).to be_nil
    expect(model.parsing_data['steps']).to be_nil
    expect(model.parsing_data['examples']).to be_nil
  end

  it "does not store parsing data for an example's children" do
    model = feature.outlines.first.examples.first

    expect(model.parsing_data['tags']).to be_nil
    expect(model.parsing_data['rows']).to be_nil
  end

  it "does not store parsing data for an example row's children" do
    model = feature.outlines.first.examples.first.rows.first

    expect(model.parsing_data['cells']).to be_nil
  end

  it "does not store parsing data for a step's children, table" do
    model = feature.outlines.first.steps.first

    expect(model.parsing_data['rows']).to be_nil
  end

  it "does not store parsing data for a step's children, doc string" do
    model = feature.outlines.first.steps.last

    expect(model.parsing_data['doc_string']).to be_nil
  end

  it "does not store parsing data for a table's children" do
    model = feature.outlines.first.steps.first.block

    expect(model.parsing_data).to be_empty
  end

  it "does not store parsing data for a table row's children" do
    model = feature.outlines.first.steps.first.block.rows.first

    expect(model.parsing_data['cells']).to be_nil
  end

end
