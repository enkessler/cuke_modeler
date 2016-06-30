module CukeModeler

  # A class modeling a basic element of a test suite.

  class ModelElement

    include Nested


    # Creates a new ModelElement object and, if *parsed_element* is provided,
    # populates the object.
    def initialize(parsed_element = nil)
      # This should be overridden by a child class
    end

    def to_s
      # This should be overridden by a child class
      super
    end

    # Returns the model objects that belong to this model.
    def children
      # This should be overridden by a child class
      []
    end


    private


    def process_source(source)
      source.is_a?(String) ? parse_model(source) : source
    end

  end
end
