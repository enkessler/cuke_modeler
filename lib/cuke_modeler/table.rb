module CukeModeler

  # A class modeling the table of a Step.

  class Table < ModelElement

    include Containing
    include Raw


    # The row objects that make up the table
    attr_accessor :rows


    # Creates a new Table object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      @rows = []

      parsed_table = process_source(source)

      build_table(parsed_table) if parsed_table
    end

    # Returns a gherkin representation of the table.
    def to_s
      rows.empty? ? '' : rows.collect { |row| row_output_string(row) }.join("\n")
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature:\nScenario:\n* step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_table.feature')

      parsed_file.first['elements'].first['steps'].first['rows']
    end

    def build_table(table)
      populate_row_elements(table)
      populate_raw_element(table)
    end

    def populate_row_elements(table)
      table['rows'].each do |row|
        @rows << build_child_element(TableRow, row)
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
      rows.collect { |row| row.cells[index].length }.max || 0
    end

  end
end
