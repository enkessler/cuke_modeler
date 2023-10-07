# I'll take extra class length due to extra helper methods over having fewer but more complex methods
# rubocop:disable Metrics/ClassLength

module CukeModeler

  # A class modeling an example table of an outline.
  class Example < Model

    include Parsing
    include Parsed
    include Named
    include Described
    include Sourceable
    include Taggable


    # The example's keyword
    attr_accessor :keyword

    # The row models in the example table
    attr_accessor :rows


    # Creates a new Example object and, if *source_text* is provided,
    # populates the object.
    def initialize(source_text = nil)
      @tags = []
      @rows = []

      super(source_text)
    end

    # Adds a row to the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values which
    # will be assigned in order.
    def add_row(row)
      raise('Cannot add a row. No parameters have been set.') if rows.empty?

      # A quick 'deep clone' so that the input isn't modified
      row = Marshal.load(Marshal.dump(row))

      values = if row.is_a?(Array)
                 row
               elsif row.is_a?(Hash)
                 # There is no guarantee that the user built up their hash with the keys in the same order as
                 # the parameter row and so the values have to be ordered by us. Additionally, the hash needs
                 # to have string keys in order for #order_row_values to work
                 ordered_row_values(stringify_keys(row))
               else
                 raise(ArgumentError, "Can only add row from a Hash or an Array but received #{row.class}")
               end

      @rows << Row.new("|#{values.join('|')}|")
    end

    # Removes a row from the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values
    # which will be assigned in order.
    def remove_row(row_removed)
      return if argument_rows.empty?

      values = if row_removed.is_a?(Array)
                 row_removed
               elsif row_removed.is_a?(Hash)
                 # There is no guarantee that the user built up their hash with the keys in the same order as
                 # the parameter row and so the values have to be ordered by us.
                 ordered_row_values(row_removed)
               else
                 raise(ArgumentError, "Can only remove row from a Hash or an Array but received #{row_removed.class}")
               end

      location = index_for_values(values.map(&:to_s).map(&:strip))
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
      parameter_row ? parameter_row.cells.map(&:value) : []
    end

    # Returns the model objects that belong to this model.
    def children
      rows + tags
    end

    # Building strings just isn't pretty
    # rubocop:disable Metrics/AbcSize

    # Returns a string representation of this model. For an example model,
    # this will be Gherkin text that is equivalent to the example being modeled.
    def to_s
      text = ''

      text << "#{tag_output_string}\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n#{description_output_string}" unless no_description_to_output?
      text << "\n" unless rows.empty? || no_description_to_output?
      text << "\n#{parameters_output_string}" if parameter_row
      text << "\n#{rows_output_string}" unless argument_rows.empty?

      text
    end

    # rubocop:enable Metrics/AbcSize

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For an example model, this will be the name of the example.
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @name: #{name.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}: Fake feature to parse
                            #{dialect_outline_keyword}:
                              #{dialect_step_keyword} fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_example.feature')

      parsed_file['feature']['elements'].first['examples'].first
    end

    def populate_model(parsed_example_data)
      populate_parsing_data(parsed_example_data)
      populate_keyword(parsed_example_data)
      populate_source_location(parsed_example_data)
      populate_name(parsed_example_data)
      populate_description(parsed_example_data)
      populate_tags(parsed_example_data)
      populate_example_rows(parsed_example_data)
    end

    def populate_example_rows(parsed_example_data)
      parsed_example_data['rows'].each do |row_data|
        @rows << build_child_model(Row, row_data)
      end
    end

    def determine_buffer_size(index)
      rows.collect { |row| row.cells[index].to_s.length }.max || 0
    end

    def parameters_output_string
      text = ''

      unless parameter_row.nil?
        text << '  |'
        parameter_row.cells.count.times { |index| text << " #{string_for(parameter_row.cells, index)} |" }
      end

      text
    end

    def rows_output_string
      text = ''

      unless argument_rows.empty?

        argument_rows.each do |row|
          text << '  |'
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
      parameter_row.cells.map(&:value).collect { |parameter| row_hash[parameter] }
    end

    def stringify_keys(hash)
      hash.each_with_object({}) { |(key, value), new_hash| new_hash[key.to_s] = value }
    end

    def index_for_values(values)
      argument_rows.index { |row| row.cells.map(&:value) == values }
    end

  end
end

# rubocop:enable Metrics/ClassLength
