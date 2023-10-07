module CukeModeler

  # A class modeling a single cell of a row.
  class Cell < Model

    include Sourceable
    include Parsing
    include Parsed


    # The value of the cell
    attr_accessor :value


    # Creates a new Cell object and, if *source_text* is provided, populates
    # the object.
    #
    # @example
    #   Cell.new
    #   Cell.new('some value')
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    def initialize(source_text = nil)
      super(source_text)
    end

    # Returns a string representation of this model. For a cell model,
    # this will be Gherkin text that is equivalent to the cell being modeled.
    def to_s
      # Vertical bars and backslashes are special characters that need to be escaped
      @value ? @value.gsub('\\', '\\\\\\').gsub('|', '\|') : ''
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a cell model, this will be the value of the cell.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @value: #{value.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}: Fake feature to parse
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} fake step\n"
      source_text = "#{base_file_string}|#{source_text}|"

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_cell.feature')

      parsed_file['feature']['elements'].first['steps'].first['table']['rows'].first['cells'].first
    end

    def populate_model(parsed_cell_data)
      populate_cell_value(parsed_cell_data)
      populate_source_location(parsed_cell_data)
      populate_parsing_data(parsed_cell_data)
    end

    def populate_cell_value(parsed_cell_data)
      @value = parsed_cell_data['value']
    end

  end

end
