module CukeModeler

  # A class modeling a basic element of a test suite.

  class ModelElement

    include Nested
    include Containing


    # Creates a new ModelElement object and, if *parsed_element* is provided,
    # populates the object.
    def initialize(source_text = nil)
      raise(ArgumentError, "Can only create models from Strings but was given a #{source_text.class}.") if source_text && !source_text.is_a?(String)

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

  end
end
