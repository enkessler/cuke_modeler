module CukeModeler

  # A class modeling the table of a Step.

  class Table < ModelElement

    include Parsed
    include Sourceable


    # The row objects that make up the table
    attr_accessor :rows


    # Creates a new Table object and, if *source* is provided, populates
    # the object.
    def initialize(source_text = nil)
      @rows = []

      super(source_text)

      if source_text
        parsed_table_data = parse_source(source_text)
        populate_table(self, parsed_table_data)
      end
    end

    # Returns the model objects that belong to this model.
    def children
      rows
    end

    # Returns a gherkin representation of the table.
    def to_s
      rows.empty? ? '' : rows.collect { |row| row_output_string(row) }.join("\n")
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature:\nScenario:\n* step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_table.feature')

      parsed_file.first['elements'].first['steps'].first['table']
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
