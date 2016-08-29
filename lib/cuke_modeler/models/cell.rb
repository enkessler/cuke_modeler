module CukeModeler

  class Cell < Model

    include Sourceable
    include Parsed


    # The value of the cell
    attr_accessor :value


    # Creates a new Cell object and, if *source* is provided, populates
    # the object.
    def initialize(source_text = nil)
      super(source_text)

      if source_text
        parsed_cell_data = parse_source(source_text)
        populate_cell(self, parsed_cell_data)
      end
    end

    # Returns a gherkin representation of the cell.
    def to_s
      # Vertical bars and backslashes are special characters that need to be escaped
      @value ? @value.gsub('\\', '\\\\\\').gsub('|', '\|') : ''
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n* fake step\n"
      source_text = base_file_string + '|' + source_text + '|'

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_cell.feature')

      parsed_file.first['elements'].first['steps'].first['table']['rows'].first['cells'].first
    end

  end

end
