module CukeModeler

  # A class modeling a Tag.

  class Tag < Model

    include Parsed
    include Sourceable


    # The name of the Tag
    attr_accessor :name


    # Creates a new Tag object and, if *source* is provided, populates the
    # object.
    def initialize(source_text = nil)
      super(source_text)

      if source_text
        parsed_tag_data = parse_source(source_text)
        populate_tag(self, parsed_tag_data)
      end
    end

    # Returns gherkin representation of the tag.
    def to_s
      name || ''
    end


    private


    def parse_source(source_text)
      base_file_string = "\nFeature: Fake feature to parse"
      source_text = source_text + base_file_string

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_tag.feature')

      parsed_file.first['tags'].first
    end

  end
end
