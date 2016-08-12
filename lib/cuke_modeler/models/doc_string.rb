module CukeModeler

  # A class modeling the Doc String of a Step.

  class DocString < Model

    include Parsed
    include Sourceable


    # The content type associated with the doc string
    attr_accessor :content_type

    # The contents of the doc string
    attr_accessor :contents


    # Creates a new DocString object and, if *source* is provided, populates
    # the object.
    def initialize(source_text = nil)
      @contents = ''

      super(source_text)

      if source_text
        parsed_doc_string_data = parse_source(source_text)
        populate_docstring(self, parsed_doc_string_data)
      end
    end

    # Returns a gherkin representation of the doc string.
    def to_s
      text = "\"\"\"#{content_type_output_string}\n"
      text << contents_output_string
      text << '"""'
    end


    private


    def parse_source(source_text)
      base_file_string = "Feature:\nScenario:\n* step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_doc_string.feature')

      parsed_file.first['elements'].first['steps'].first['doc_string']
    end

    def content_type_output_string
      content_type ? " #{content_type}" : ''
    end

    def contents_output_string
      contents.empty? ? '' : contents.gsub('"""', '\"\"\"') + "\n"
    end

  end
end
