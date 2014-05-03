module CukeModeler

  # A class modeling a Cucumber feature's Background.

  class Background < ModelElement

    include Named

    # Creates a new Background object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      @name = ''

      build_background(source) if source
    end

    # Returns gherkin representation of the background.
    def to_s
      ''
    end


    private


    def build_background(parsed_background)
      populate_name(parsed_background)
    end

  end
end
