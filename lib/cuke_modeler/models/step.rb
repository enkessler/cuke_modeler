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

      return unless source_text

      parsed_step_data = parse_source(source_text)
      populate_step(self, parsed_step_data)
    end

    # Returns *true* if the two steps have the same base text (i.e. minus any keyword,
    # table, or doc string and *false* otherwise.
    def ==(other)
      return false unless other.is_a?(CukeModeler::Step)

      text_matches?(other) &&
        table_matches?(other) &&
        doc_string_matches?(other)
    end

    # Returns the model objects that belong to this model.
    def children
      block ? [block] : []
    end

    # Returns a string representation of this model. For a step model,
    # this will be Gherkin text that is equivalent to the step being modeled.
    def to_s
      text = "#{keyword} #{self.text}"
      text << "\n#{block.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")}" if block

      text
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a step model, this will be the text of the step.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @text: #{@text.inspect}>"
    end


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}: Fake feature to parse
                            #{dialect_scenario_keyword}:\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_step.feature')

      parsed_file['feature']['elements'].first['steps'].first
    end

    def text_matches?(other_step)
      text == other_step.text
    end

    def table_matches?(other_step)
      return false if only_one_step_has_table?(other_step)
      return true if neither_step_has_table?(other_step)

      first_step_values = block.rows.collect { |table_row| table_row.cells.map(&:value) }
      second_step_values = other_step.block.rows.collect { |table_row| table_row.cells.map(&:value) }

      first_step_values == second_step_values
    end

    def doc_string_matches?(other_step)
      return false if only_one_step_has_doc_string?(other_step)
      return true if neither_step_has_doc_string?(other_step)

      first_content       = block.content
      first_content_type  = block.content_type
      second_content      = other_step.block.content
      second_content_type = other_step.block.content_type

      (first_content == second_content) &&
        (first_content_type == second_content_type)
    end

    def only_one_step_has_table?(other_step)
      (!block.is_a?(CukeModeler::Table) || !other_step.block.is_a?(CukeModeler::Table)) &&
        (block.is_a?(CukeModeler::Table) || other_step.block.is_a?(CukeModeler::Table))
    end

    def neither_step_has_table?(other_step)
      !block.is_a?(CukeModeler::Table) &&
        !other_step.block.is_a?(CukeModeler::Table)
    end

    def only_one_step_has_doc_string?(other_step)
      (!block.is_a?(CukeModeler::DocString) || !other_step.block.is_a?(CukeModeler::DocString)) &&
        (block.is_a?(CukeModeler::DocString) || other_step.block.is_a?(CukeModeler::DocString))
    end

    def neither_step_has_doc_string?(other_step)
      !block.is_a?(CukeModeler::DocString) &&
        !other_step.block.is_a?(CukeModeler::DocString)
    end

  end
end
