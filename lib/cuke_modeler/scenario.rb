module CukeModeler

  # A class modeling a Cucumber Scenario.

  class Scenario < ModelElement

    include Named


    # Creates a new Scenario object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      @name = ''

      build_scenario(source) if source
    end

    # Returns gherkin representation of the scenario.
    def to_s
      ''
    end


    private


    def build_scenario(parsed_scenario)
      populate_name(parsed_scenario)
    end

  end
end
