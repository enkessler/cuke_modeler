module CukeModeler

  # A class modeling a step's doc string.
  class DocString < Model

    include Parsing
    include Parsed
    include Sourceable


    # The content type associated with the doc string
    attr_accessor :content_type

    # The content of the doc string
    attr_accessor :content


    # Creates a new DocString object and, if *source_text* is provided, populates
    # the object.
    #
    # @example
    #   DocString.new
    #   DocString.new("\"\"\" some_type\n  foo\n\"\"\"")
    #
    # @param source_text [String] The Gherkin text that will be used to populate the model
    # @raise [ArgumentError] If *source_text* is not a String
    # @return [DocString] A new DocString instance
    def initialize(source_text = nil)
      super(source_text)
    end

    # Returns a string representation of this model. For a DocString model,
    # this will be Gherkin text that is equivalent to the doc string being modeled.
    #
    # @example
    #   doc_string.to_s
    #
    # @return [String] A string representation of this model
    def to_s
      text = "\"\"\"#{content_type_output_string}\n"
      text << content_output_string
      text << '"""'
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a DocString model, this will be the content of the
    # doc string. If *verbose* is true, provides default Ruby inspection
    # behavior instead.
    #
    # @example
    #   doc_string.inspect
    #   doc_string.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @content: #{content.inspect}>"
    end


    private


    def process_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}:
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_doc_string.feature')

      parsed_file['feature']['elements'].first['steps'].first['doc_string']
    end

    def populate_model(parsed_doc_string_data)
      populate_content_type(parsed_doc_string_data)
      populate_content(parsed_doc_string_data)
      populate_parsing_data(parsed_doc_string_data)
      populate_source_location(parsed_doc_string_data)
    end

    def populate_content_type(parsed_doc_string_data)
      @content_type = parsed_doc_string_data['content_type']
    end

    def populate_content(parsed_doc_string_data)
      @content = parsed_doc_string_data['value']
    end

    def content_type_output_string
      content_type ? " #{content_type}" : ''
    end

    def content_output_string
      content.nil? || content.empty? ? '' : "#{content.gsub('"""', '\"\"\"')}\n"
    end

  end
end
