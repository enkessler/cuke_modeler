module CukeModeler

  # A class modeling a tag.

  class Tag < ModelElement

    include Named


    # Creates a new Tag object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      @name = ''

      build_tag(source) if source
    end

    # Returns gherkin representation of the tag.
    def to_s
      ''
    end


    private


    def build_tag(parsed_tag)
      populate_name(parsed_tag)
    end

  end
end
