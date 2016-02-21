module CukeModeler

  # A class modeling the table of a Step.

  class Table

    include Containing
    include Raw
    include Nested


    # The contents of the table
    #
    # Deprecated
    attr_accessor :contents

    # The row elements that make up the table
    attr_accessor :row_elements


    # Creates a new Table object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      @contents = []
      @row_elements = []

      parsed_table = process_source(source)

      build_table(parsed_table) if parsed_table
    end

    # Returns a gherkin representation of the table.
    def to_s
      row_elements.empty? ? '' : row_elements.collect { |row| row_output_string(row) }.join("\n")
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_table(source)
        else
          source
      end
    end

    def parse_table(source_text)
      base_file_string = "Feature:\nScenario:\n* step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_table.feature')

      parsed_file.first['elements'].first['steps'].first['rows']
    end

    def build_table(table)
      populate_contents(table)
      populate_row_elements(table)
      populate_raw_element(table)
    end

    def populate_contents(table)
      @contents = table['rows'].collect { |row| row['cells'] }
    end

    def populate_row_elements(table)
      table['rows'].each do |row|
        @row_elements << build_child_element(TableRow, row)
      end
    end

    def row_output_string(row)
      row_text = '|'

      row.cells.count.times do |count|
        row_text << " #{row.cells[count].ljust(determine_buffer_size(count))} |"
      end

      row_text
    end

    def determine_buffer_size(index)
      row_elements.collect { |row| row.cells[index].length }.max || 0
    end

  end
end
