module CukeModeler

  # A class modeling a step table row.

  class TableRow < ModelElement

    include Sourceable
    include Raw


    # The cells that make up the row
    attr_accessor :cells


    # Creates a new TableRow object and, if *source* is provided, populates
    # the object.
    def initialize(source_text = nil)
      @cells = []

      super(source_text)

      if source_text
        parsed_row_data = parse_source(source_text)
        populate_row(self, parsed_row_data)
      end
    end

    # Returns a gherkin representation of the table row.
    def to_s
      text_cells = cells.collect { |cell| cell.to_s }

      "| #{text_cells.join(' | ')} |"
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n* fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_table_row.feature')

      parsed_file.first['elements'].first['steps'].first['table']['rows'].first
    end

  end
end
