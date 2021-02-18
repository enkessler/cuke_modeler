module CukeModeler

  # A class modeling an element of a Cucumber suite.
  class Model

    include Nested
    include Containing


    # Creates a new Model object and, if *source_text* is provided,
    # populates the object.
    def initialize(source_text = nil)
      error_message = "Can only create models from Strings but was given a #{source_text.class}."
      raise(ArgumentError, error_message) if source_text && !source_text.is_a?(String)

      # This should be overridden by a child class
    end

    # Returns a string representation of this model.
    def to_s
      # This should be overridden by a child class
      super
    end

    # Returns the model objects that belong to this model.
    def children
      []
    end

  end
end
