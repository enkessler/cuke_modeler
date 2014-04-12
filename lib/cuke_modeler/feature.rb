module CukeModeler

  # A class modeling a Cucumber Feature.

  class Feature < ModelElement

    include Named


    # Creates a new Feature object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_feature = process_source(source)

      @name = ''

      build_feature(parsed_feature) if parsed_feature
    end

    # Returns a gherkin representation of the feature.
    def to_s
      ''
    end


    private


    def process_source(source)
      source.is_a?(String) ? parse_feature(source) : source
    end

    def parse_feature(source_text)
      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first
    end

    def build_feature(parsed_feature)
      populate_name(parsed_feature)
    end

  end
end
