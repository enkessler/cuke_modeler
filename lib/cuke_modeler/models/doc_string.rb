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
    def initialize(source_text = nil)
      super(source_text)

      return unless source_text

      parsed_doc_string_data = parse_source(source_text)
      populate_docstring(self, parsed_doc_string_data)
    end

    # Returns a string representation of this model. For a doc string model,
    # this will be Gherkin text that is equivalent to the doc string being modeled.
    def to_s
      text = "\"\"\"#{content_type_output_string}\n"
      text << content_output_string
      text << '"""'
    end


    private


    def parse_source(source_text)
      base_file_string = "# language: #{Parsing.dialect}
      #{dialect_feature_keyword}:
                            #{dialect_scenario_keyword}:
                              #{dialect_step_keyword} step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing.parse_text(source_text, 'cuke_modeler_stand_alone_doc_string.feature')

      parsed_file['feature']['elements'].first['steps'].first['doc_string']
    end

    def content_type_output_string
      content_type ? " #{content_type}" : ''
    end

    def content_output_string
      content.nil? || content.empty? ? '' : content.gsub('"""', '\"\"\"') + "\n"
    end

  end
end
