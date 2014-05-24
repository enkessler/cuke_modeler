module CukeModeler

  # A class modeling a Cucumber Feature.

  class Step < ModelElement

    # The base text of the step
    attr_accessor :base


    # Creates a new Step object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      @base = ''

      build_step(source) if source
    end

    # Returns a gherkin representation of the step.
    def to_s
      ''
    end


    private


    def build_step(step)
      populate_base(step)
    end

    def populate_base(step)
      @base = step['name']
    end

  end
end
