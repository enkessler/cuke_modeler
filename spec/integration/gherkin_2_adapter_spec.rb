require 'spec_helper'

SimpleCov.command_name('Gherkin2Adapter') unless RUBY_VERSION.to_s < '1.9.0'


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

    expect(model.raw_element['tags']).to be_nil
    expect(model.raw_element['elements']).to be_nil
  end

  it "does not store parsing data for a background's children" do
    model = feature.background

    expect(model.raw_element['steps']).to be_nil
  end

  it "does not store parsing data for a scenario's children" do
    model = feature.scenarios.first

    expect(model.raw_element['tags']).to be_nil
    expect(model.raw_element['steps']).to be_nil
  end

  it "does not store parsing data for an outline's children" do
    model = feature.outlines.first

    expect(model.raw_element['tags']).to be_nil
    expect(model.raw_element['steps']).to be_nil
    expect(model.raw_element['examples']).to be_nil
  end

  it "does not store parsing data for an example's children" do
    model = feature.outlines.first.examples.first

    expect(model.raw_element['tags']).to be_nil
    expect(model.raw_element['rows']).to be_nil
  end

  it "does not store parsing data for a step's children, table" do
    model = feature.outlines.first.steps.first

    expect(model.raw_element['rows']).to be_nil
  end

  it "does not store parsing data for a step's children, doc string" do
    model = feature.outlines.first.steps.last

    expect(model.raw_element['doc_string']).to be_nil
  end

  it "does not store parsing data for a table's children" do
    model = feature.outlines.first.steps.first.block

    expect(model.raw_element).to be_empty
  end

end