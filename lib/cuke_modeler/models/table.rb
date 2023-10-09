module CukeModeler

  # A class modeling a step's table.
  class Table < Model

    include Parsing
    include Parsed
    include Sourceable


    # The row models that make up the table
    attr_accessor :rows


    # Creates a new Table object and, if *source_text* is provided, populates
    # the object.
    #
    # @example
    #   Table.new
    #   Table.new("|value_1|value_2|\n|value_3|value_4|")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Table] A new Table instance
    def initialize(source_text = nil)
      @rows = []

      super(source_text)
    end

    # Returns the model objects that are children of this model. For a
    # Table model, these would be any associated Row models.
    #
    # @example
    #   table.children
    #
    # @return [Array<Model>] A collection of child models
    def children
      rows
    end

    # Returns a string representation of this model. For a table model,
    # this will be Gherkin text that is equivalent to the table being modeled.
    #
    # @example
    #   table.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      rows.empty? ? '' : rows.collect { |row| row_output_string(row) }.join("\n")
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a table model, this will be the rows of the table.
    # If *verbose* is true, provides default Ruby inspection behavior
    # instead.
    #
    # @example
    #   table.inspect
    #   table.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      row_output = @rows&.collect { |row| row.cells.collect(&:value) }

      "#{super.chop} @rows: #{row_output.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}:
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_table.feature')

      parsed_file['feature']['elements'].first['steps'].first['table']
    end

    def populate_model(parsed_table_data)
      populate_row_models(parsed_table_data)
      populate_parsing_data(parsed_table_data)
      populate_source_location(parsed_table_data)
    end

    def populate_row_models(parsed_table_data)
      parsed_table_data['rows'].each do |row_data|
        @rows << build_child_model(Row, row_data)
      end
    end

    def row_output_string(row)
      row_text = '|'

      row.cells.count.times do |count|
        row_text << " #{row.cells[count].to_s.ljust(determine_buffer_size(count))} |"
      end

      row_text
    end

    def determine_buffer_size(index)
      rows.collect { |row| row.cells[index].to_s.length }.max || 0
    end

  end
end
