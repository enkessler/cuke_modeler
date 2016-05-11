module CukeModeler

  # A class modeling a Tag.

  class Tag < ModelElement

    include Raw
    include Sourceable


    # The name of the Tag
    attr_accessor :name


    # Creates a new Tag object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_tag = process_source(source)

      build_tag(parsed_tag) if parsed_tag
    end

    # Returns gherkin representation of the tag.
    def to_s
      name || ''
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_tag(source)
        else
          source
      end
    end

    def parse_tag(source_text)
      base_file_string = "\nFeature: Fake feature to parse"
      source_text = source_text + base_file_string

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_tag.feature')

      parsed_file.first['tags'].first
    end

    def build_tag(parsed_tag)
      populate_name(parsed_tag)
      populate_raw_element(parsed_tag)
      populate_element_source_line(parsed_tag)
    end

    def populate_name(parsed_tag)
      @name = parsed_tag['name']
    end

  end
end
