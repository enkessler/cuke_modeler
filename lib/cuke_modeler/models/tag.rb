module CukeModeler

  # A class modeling a tag.
  class Tag < Model

    include Parsing
    include Parsed
    include Sourceable
    include Named


    # Creates a new Tag object and, if *source_text* is provided, populates the
    # object.
    #
    # @example
    #   Tag.new
    #   Tag.new('@a_tag')
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [Tag] A new Tag instance
    def initialize(source_text = nil)
      super(source_text)
    end

    # Returns a string representation of this model. For a Tag model,
    # this will be Gherkin text that is equivalent to the tag being modeled.
    #
    # @example
    #   tag.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      name || ''
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a Tag model, this will be the name of the tag. If
    # *verbose* is true, provides default Ruby inspection behavior instead.
    #
    # @example
    #   tag.inspect
    #   tag.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @name: #{@name.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "\n#{dialect_feature_keyword}: Fake feature to parse"
      source_text = "# language: #{Parsing.dialect}\n" + source_text + base_file_string

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_tag.feature')

      parsed_file['feature']['tags'].first
    end

    def populate_model(processed_tag_data)
      populate_name(processed_tag_data)
      populate_parsing_data(processed_tag_data)
      populate_source_location(processed_tag_data)
    end

  end
end
