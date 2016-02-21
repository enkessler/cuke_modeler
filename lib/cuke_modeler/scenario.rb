module CukeModeler

  # A class modeling a Cucumber Scenario.

  class Scenario < TestElement

    include Taggable


    # Creates a new Scenario object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_scenario = process_source(source, 'cuke_modeler_stand_alone_scenario.feature')

      super(parsed_scenario)

      @tags = []
      @tag_elements = []

      build_scenario(parsed_scenario) if parsed_scenario
    end

    # Returns gherkin representation of the scenario.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Scenario:#{name_output_string}"
      text << "\n" + description_output_string unless description_text.empty?
      text << "\n" unless steps.empty? || description_text.empty?
      text << "\n" + steps_output_string unless steps.empty?

      text
    end


    private


    def build_scenario(scenario)
      populate_element_tags(scenario)
    end

  end
end
