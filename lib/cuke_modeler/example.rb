module CukeModeler

  # A class modeling a Cucumber Examples table.

  class Example < FeatureElement

    include Taggable
    include Containing


    # The argument rows in the example table
    #
    # todo - Make this a read only method that derives the rows from
    # the row elements
    attr_accessor :rows

    # The parameters for the example table
    #
    # todo - Make this a read only method that derives the parameters from
    # the row elements
    attr_accessor :parameters

    # The row elements in the example table
    attr_accessor :row_elements


    # Creates a new Example object and, if *source* is provided,
    # populates the object.
    def initialize(source = nil)
      parsed_example = process_source(source)

      super(parsed_example)

      @tags = []
      @tag_elements = []
      @rows = []
      @parameters = []
      @row_elements = []

      build_example(parsed_example) if parsed_example
    end

    # Adds a row to the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values which
    # will be assigned in order.
    def add_row(row)
      raise('Cannot add a row. No parameters have been set.') if @parameters.empty?

      # A quick 'deep clone' so that the input isn't modified
      row = Marshal::load(Marshal.dump(row))

      case
        when row.is_a?(Array)
          # 'stringify' input
          row.collect! { |value| value.to_s }

          @rows << Hash[@parameters.zip(row.collect { |value| value.strip })]
          @row_elements << Row.new("|#{row.join('|')}|")
        when row.is_a?(Hash)
          # 'stringify' input
          row = row.inject({}) { |hash, (key, value)| hash[key.to_s] = value.to_s; hash }

          @rows << row.each_value { |value| value.strip! }
          @row_elements << Row.new("|#{ordered_row_values(row).join('|')}|")
        else
          raise(ArgumentError, "Can only add row from a Hash or an Array but received #{row.class}")
      end
    end

    # Removes a row from the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values
    # which will be assigned in order.
    def remove_row(row)
      case
        when row.is_a?(Array)
          location = @rows.index { |row_hash| row_hash.values_at(*@parameters) == row.collect { |value| value.strip } }
        when row.is_a?(Hash)
          location = @rows.index { |row_hash| row_hash == row.each_value { |value| value.strip! } }
        else
          raise(ArgumentError, "Can only remove row from a Hash or an Array but received #{row.class}")
      end

      #todo - remove once Hash rows are no longer supported
      @rows.delete_at(location) if location
      @row_elements.delete_at(location + 1) if location
    end

    # Returns the immediate child elements of the element.
    def contains
      @row_elements
    end

    # Returns a gherkin representation of the example.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Examples:#{name_output_string}"
      text << "\n" + description_output_string unless description_text.empty?
      text << "\n" unless description_text.empty?
      text << "\n" + parameters_output_string
      text << "\n" + rows_output_string unless rows.empty?

      text
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_example(source)
        else
          source
      end
    end

    def parse_example(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario Outline:\n* fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_example.feature')

      parsed_file.first['elements'].first['examples'].first
    end

    def build_example(parsed_example)
      populate_element_tags(parsed_example)
      populate_example_row_elements(parsed_example)
      populate_example_parameters
      populate_example_rows
    end

    def populate_example_parameters
      @parameters = @row_elements.first.cells unless @row_elements.empty?
    end

    def populate_example_rows
      @row_elements.each do |row|
        @rows << Hash[@parameters.zip(row.cells)]
      end

      @rows.shift
    end

    def populate_example_row_elements(parsed_example)
      parsed_example['rows'].each do |row|
        @row_elements << build_child_element(Row, row)
      end
    end

    def determine_buffer_size(index)
      row_elements.collect { |row| row.cells[index].length }.max || 0
    end

    def parameters_output_string
      text = ''

      unless parameters.empty?
        text << "  |"
        parameters.count.times { |index| text << " #{string_for(parameters, index)} |" }
      end

      text
    end

    def rows_output_string
      text = ''

      unless rows.empty?

        rows.each do |row|
          text << "  |"
          row.values.count.times { |index| text << " #{string_for(ordered_row_values(row), index)} |" }
          text << "\n"
        end

        text.chomp!
      end

      text
    end

    def string_for(cells, index)
      cells[index] ? cells[index].ljust(determine_buffer_size(index)) : ''
    end

    def ordered_row_values(row_hash)
      @parameters.collect { |parameter| row_hash[parameter] }
    end

  end
end
