module CukeModeler

  # A class modeling a tag.

  class Tag < Model

    include Parsing
    include Parsed
    include Sourceable


    # The name of the tag
    attr_accessor :name


    # Creates a new Tag object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      super(source_text)

      if source_text
        parsed_tag_data = parse_source(source_text)
        populate_tag(self, parsed_tag_data)
      end
    end

    # Returns a string representation of this model. For a tag model,
    # this will be Gherkin text that is equivalent to the tag being modeled.
    def to_s
      name || ''
    end


    private


    def parse_source(source_text)
      base_file_string = "\n#{dialect_feature_keyword}: Fake feature to parse"
      source_text = source_text + base_file_string

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_tag.feature')

      parsed_file.first['tags'].first
    end

  end
end
