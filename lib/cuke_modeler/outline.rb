module CukeModeler

  # A class modeling a Cucumber Scenario Outline.

  class Outline < ModelElement

    include Named


    # Creates a new Outline object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      @name = ''

      build_outline(source) if source
    end

    # Returns a gherkin representation of the outline.
    def to_s
      ''
    end


    private


    def build_outline(parsed_outline)
      populate_name(parsed_outline)
    end

  end
end
