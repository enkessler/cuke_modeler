module CukeModeler

  # A class modeling a Cucumber Scenario.

  class Scenario < ModelElement

    include Raw
    include Named
    include Described
    include Stepped
    include Sourceable
    include Containing
    include Taggable


    # Creates a new Scenario object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_scenario = process_source(source, 'cuke_modeler_stand_alone_scenario.feature')

      super(parsed_scenario)

      @name = ''
      @description = ''
      @description_text = []
      @steps = []
      @tags = []
      @tag_elements = []

      build_scenario(parsed_scenario) if parsed_scenario
    end

    # Returns true if the two elements have equivalent steps and false otherwise.
    def ==(other_element)
      return false unless other_element.respond_to?(:steps)

      steps == other_element.steps
    end

    def children
      steps
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


    def parse_model(source_text, file_name)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, file_name)

      parsed_file.first['elements'].first
    end

    def build_scenario(parsed_scenario)
      populate_raw_element(parsed_scenario)
      populate_element_source_line(parsed_scenario)
      populate_name(parsed_scenario)
      populate_description(parsed_scenario)
      populate_steps(parsed_scenario)
      populate_element_tags(parsed_scenario)
    end

  end
end
