module CukeModeler

  # A class modeling a Cucumber Examples table.

  class Example < ModelElement

    include Parsed
    include Named
    include Described
    include Sourceable
    include Taggable


    # The row objects in the example table
    attr_accessor :rows


    # Creates a new Example object and, if *source* is provided,
    # populates the object.
    def initialize(source_text = nil)
      @name = ''
      @description = ''
      @tags = []
      @rows = []

      super(source_text)

      if source_text
        parsed_example_data = parse_source(source_text)
        populate_example(self, parsed_example_data)
      end
    end

    # Adds a row to the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values which
    # will be assigned in order.
    def add_row(row)
      raise('Cannot add a row. No parameters have been set.') if rows.empty?

      # A quick 'deep clone' so that the input isn't modified
      row = Marshal::load(Marshal.dump(row))

      case
        when row.is_a?(Array)
          # 'stringify' input
          row.collect! { |value| value.to_s }

          @rows << Row.new("|#{row.join('|')}|")
        when row.is_a?(Hash)
          # 'stringify' input
          row = row.inject({}) { |hash, (key, value)| hash[key.to_s] = value.to_s; hash }

          @rows << Row.new("|#{ordered_row_values(row).join('|')}|")
        else
          raise(ArgumentError, "Can only add row from a Hash or an Array but received #{row.class}")
      end
    end

    # Removes a row from the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values
    # which will be assigned in order.
    def remove_row(row_removed)
      raise(ArgumentError, "Can only remove row from a Hash or an Array but received #{row_removed.class}") unless row_removed.is_a?(Array) or row_removed.is_a?(Hash)

      return unless argument_rows

      case
        when row_removed.is_a?(Array)
          location = argument_rows.index { |row| row.cells.collect { |cell| cell.value } == row_removed.collect { |value| value.strip } }
        when row_removed.is_a?(Hash)
          # Note: the hash value order has to be manually calculated because Ruby 1.8.7 does not have ordered 
          # hash keys. Alternatively, the hash may have simply been built up 'willy nilly' by the user instead 
          # of being built up in order according to the parameter order.
          location = argument_rows.index { |row| row.cells.collect { |cell| cell.value } == ordered_row_values(row_removed.each_value { |value| value.strip! }) }
      end

      @rows.delete_at(location + 1) if location
    end

    # The argument rows in the example table
    def argument_rows
      rows[1..rows.count] || []
    end

    # The parameter row for the example table
    def parameter_row
      rows.first
    end

    # Returns the parameters of the example table
    def parameters
      rows.empty? ? [] : rows.first.cells.collect { |cell| cell.value }
    end

    # Returns the model objects that belong to this model.
    def children
      rows + tags
    end

    # Returns a gherkin representation of the example.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Examples:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?
      text << "\n" unless description.empty?
      text << "\n" + parameters_output_string
      text << "\n" + rows_output_string unless argument_rows.empty?

      text
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario Outline:\n* fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_example.feature')

      parsed_file.first['elements'].first['examples'].first
    end

    def determine_buffer_size(index)
      rows.collect { |row| row.cells[index].to_s.length }.max || 0
    end

    def parameters_output_string
      text = ''

      unless parameter_row.nil?
        text << "  |"
        parameter_row.cells.count.times { |index| text << " #{string_for(parameter_row.cells, index)} |" }
      end

      text
    end

    def rows_output_string
      text = ''

      unless argument_rows.empty?

        argument_rows.each do |row|
          text << "  |"
          row.cells.count.times { |index| text << " #{string_for(row.cells, index)} |" }
          text << "\n"
        end

        text.chomp!
      end

      text
    end

    def string_for(cells, index)
      cells[index] ? cells[index].to_s.ljust(determine_buffer_size(index)) : ''
    end

    def ordered_row_values(row_hash)
      parameter_row.cells.collect { |cell| cell.value }.collect { |parameter| row_hash[parameter] }
    end

  end
end
