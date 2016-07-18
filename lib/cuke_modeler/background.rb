module CukeModeler

  # A class modeling a Cucumber feature's Background.

  class Background < ModelElement

    include Parsed
    include Named
    include Described
    include Stepped
    include Sourceable


    # Creates a new Background object and, if *source* is provided, populates
    # the object.
    def initialize(source_text = nil)
      @name = ''
      @description = ''
      @steps = []

      super(source_text)

      if source_text
        parsed_background_data = parse_source(source_text)
        populate_background(self, parsed_background_data)
      end
    end

    # Returns true if the two models have equivalent steps and false otherwise.
    def ==(other_model)
      return false unless other_model.respond_to?(:steps)

      steps == other_model.steps
    end

    # Returns the model objects that belong to this model.
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


    def parse_source(source_text)
      base_file_string = "Feature: Fake feature to parse\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_background.feature')

      parsed_file.first['elements'].first
    end

  end
end
