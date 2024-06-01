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
    #
    # @example
    #   Step.new
    #   Step.new("Given a step")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Step] A new Step instance
    def initialize(source_text = nil)
      super
    end

    # Compares this model with another object. Returns *true* if the two objects
    # have the same base text, table, and doc string and *false* otherwise.
    #
    # @example
    #   step_1 == step_2
    #
    # @param other [Object] The object to compare this model with
    # @return [Boolean] Whether the two objects are equivalent
    def ==(other)
      return false unless other.is_a?(CukeModeler::Step)

      text_matches?(other) &&
        table_matches?(other) &&
        doc_string_matches?(other)
    end

    # Returns the model objects that are children of this model. For a
    # Step model, these would be any associated Table or DocString models.
    #
    # @example
    #   step.children
    #
    # @return [Array<Table, DocString>] A collection of child models
    def children
      block ? [block] : []
    end

    # Returns a string representation of this model. For a Step model,
    # this will be Gherkin text that is equivalent to the step being modeled.
    #
    # @example
    #   step.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      text = "#{keyword} #{self.text}"
      text << "\n#{block.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")}" if block

      text
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a Step model, this will be the text of the step.
    # If *verbose* is true, provides default Ruby inspection behavior
    # instead.
    #
    # @example
    #   step.inspect
    #   step.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super if verbose

      "#{super.chop} @text: #{@text.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}: Fake feature to parse
                            #{dialect_scenario_keyword}:\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_step.feature')

      parsed_file['feature']['elements'].first['steps'].first
    end

    def populate_model(parsed_step_data)
      populate_text(parsed_step_data)
      populate_block(parsed_step_data)
      populate_keyword(parsed_step_data)
      populate_source_location(parsed_step_data)
      populate_parsing_data(parsed_step_data)
    end

    def populate_text(parsed_step_data)
      @text = parsed_step_data['name']
    end

    def populate_block(parsed_step_data)
      @block = if parsed_step_data['table']
                 build_child_model(Table, parsed_step_data['table'])
               elsif parsed_step_data['doc_string']
                 build_child_model(DocString, parsed_step_data['doc_string'])
               end
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
