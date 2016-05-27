module CukeModeler

  # A class modeling a Cucumber feature's Background.

  class Background < ModelElement

    include Raw
    include Named
    include Described
    include Stepped
    include Sourceable
    include Containing


    # Creates a new Background object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      parsed_background = process_source(source)

      super(parsed_background)

      @name = ''
      @description = ''
      @steps = []

      build_background(parsed_background) if parsed_background
    end

    # Returns true if the two models have equivalent steps and false otherwise.
    def ==(other_model)
      return false unless other_model.respond_to?(:steps)

      steps == other_model.steps
    end

    def children
      steps
    end

    # Returns gherkin representation of the background.
    def to_s
      text = ''

      text << "Background:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?
      text << "\n" unless steps.empty? || description.empty?
      text << "\n" + steps_output_string unless steps.empty?

      text
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_background.feature')

      parsed_file.first['elements'].first
    end

    def build_background(parsed_background)
      populate_raw_element(parsed_background)
      populate_name(parsed_background)
      populate_description(parsed_background)
      populate_element_source_line(parsed_background)
      populate_steps(parsed_background)
    end

  end
end
