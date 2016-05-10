module CukeModeler

  # A class modeling a basic element of a test suite.

  class ModelElement

    include Nested


    # Creates a new ModelElement object and, if *parsed_element* is provided,
    # populates the object.
    def initialize(parsed_element = nil)
      # Nothing to do
    end

    def to_s
      super
    end

    def children
      []
    end


    private


    def process_source(source, file_name = nil)
      source.is_a?(String) ? parse_model(source, file_name) : source
    end

  end
end
