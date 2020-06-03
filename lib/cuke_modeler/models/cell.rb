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
    def initialize(source_text = nil)
      super(source_text)

      if source_text
        parsed_cell_data = parse_source(source_text)
        populate_cell(self, parsed_cell_data)
      end
    end

    # Returns a string representation of this model. For a cell model,
    # this will be Gherkin text that is equivalent to the cell being modeled.
    def to_s
      # Vertical bars and backslashes are special characters that need to be escaped
      @value ? @value.gsub('\\', '\\\\\\').gsub('|', '\|') : ''
    end


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}\n#{dialect_feature_keyword}: Fake feature to parse\n#{dialect_scenario_keyword}:\n#{dialect_step_keyword} fake step\n"
      source_text = base_file_string + '|' + source_text + '|'

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_cell.feature')

      parsed_file['feature']['elements'].first['steps'].first['table']['rows'].first['cells'].first
    end

  end

end
