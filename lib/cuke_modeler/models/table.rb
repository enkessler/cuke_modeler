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
    def initialize(source_text = nil)
      @rows = []

      super(source_text)

      return unless source_text

      parsed_table_data = parse_source(source_text)
      populate_table(self, parsed_table_data)
    end

    # Returns the model objects that belong to this model.
    def children
      rows
    end

    # Returns a string representation of this model. For a table model,
    # this will be Gherkin text that is equivalent to the table being modeled.
    def to_s
      rows.empty? ? '' : rows.collect { |row| row_output_string(row) }.join("\n")
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a table model, this will be the rows of the table.
    def inspect
      row_output = @rows&.collect { |row| row.cells.collect(&:value) }

      base = super

      "#{base.chop} @rows: #{row_output.inspect}>"
    end


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}:
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_table.feature')

      parsed_file['feature']['elements'].first['steps'].first['table']
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
