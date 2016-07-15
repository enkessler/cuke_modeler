module CukeModeler

  # A class modeling a step table row.

  class TableRow < ModelElement

    include Sourceable
    include Raw
    include Containing


    # The cells that make up the row
    attr_accessor :cells


    # Creates a new TableRow object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      parsed_row = process_source(source)

      @cells = []

      build_row(parsed_row) if parsed_row
    end

    # Returns a gherkin representation of the table row.
    def to_s
      text_cells = cells.collect { |cell| cell.to_s }

      "| #{text_cells.join(' | ')} |"
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n* fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_table_row.feature')

      #todo - rename the first 'rows' to 'table' so that it is more clear what is going on
      parsed_file.first['elements'].first['steps'].first['table']['rows'].first
    end

    def build_row(parsed_row)
      populate_source_line(parsed_row)
      populate_row_cells(parsed_row)
      populate_raw_element(parsed_row)
    end

    def populate_row_cells(parsed_row)
      parsed_row['cells'].each do |cell|
        @cells << build_child_element(Cell, cell)
      end
    end

  end
end
