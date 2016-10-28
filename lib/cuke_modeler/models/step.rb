module CukeModeler

  # A class modeling a single step of a background, scenario, or outline.

  class Step < Model

    include Sourceable
    include Parsing
    include Parsed


    # The step's keyword
    attr_accessor :keyword

    # The base text of the step
    attr_accessor :text

    # The step's passed block
    attr_accessor :block


    # Creates a new Step object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      super(source_text)

      if source_text
        parsed_step_data = parse_source(source_text)
        populate_step(self, parsed_step_data)
      end
    end

    # Returns *true* if the two steps have the same base text (i.e. minus any keyword,
    # table, or doc string and *false* otherwise.
    def ==(other_step)
      return false unless other_step.respond_to?(:text)

      text == other_step.text
    end

    # Returns the model objects that belong to this model.
    def children
      block ? [block] : []
    end

    # Returns a string representation of this model. For a step model,
    # this will be Gherkin text that is equivalent to the step being modeled.
    def to_s
      text = "#{keyword} #{self.text}"
      text << "\n" + block.to_s.split("\n").collect { |line| "  #{line}" }.join("\n") if block

      text
    end


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n#{dialect_scenario_keyword}:\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_step.feature')

      parsed_file.first['elements'].first['steps'].first
    end

  end
end
