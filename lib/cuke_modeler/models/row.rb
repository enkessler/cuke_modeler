module CukeModeler

  # A class modeling a single row of a step table or example table.
  class Row < Model

    include Sourceable
    include Parsing
    include Parsed

    # The cell models that make up the row
    attr_accessor :cells


    # Creates a new Row object and, if *source_text* is provided, populates
    # the object.
    def initialize(source_text = nil)
      @cells = []

      super(source_text)
    end

    # Returns the model objects that belong to this model.
    def children
      @cells
    end

    # Returns a string representation of this model. For a row model,
    # this will be Gherkin text that is equivalent to the row being modeled.
    def to_s
      text_cells = cells.map(&:to_s)

      "| #{text_cells.join(' | ')} |"
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a row model, this will be the cells of the row.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      cell_output = @cells&.collect(&:value)

      "#{super.chop} @cells: #{cell_output.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}: Fake feature to parse
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_row.feature')

      parsed_file['feature']['elements'].first['steps'].first['table']['rows'].first
    end

    def populate_model(parsed_row_data)
      populate_source_location(parsed_row_data)
      populate_row_cells(parsed_row_data)
      populate_parsing_data(parsed_row_data)
    end

    def populate_row_cells(parsed_row_data)
      parsed_row_data['cells'].each do |cell_data|
        @cells << build_child_model(Cell, cell_data)
      end
    end

  end
end
