module CukeModeler

  # A class modeling a Cucumber .feature file.

  class FeatureFile < ModelElement


    # Creates a new FeatureFile object and, if *file_parsed* is provided,
    # populates the object.
    def initialize(file_parsed = nil)
      @path = file_parsed || ''
    end

    # Returns the name of the modeled file.
    def name
      File.basename(@path.gsub('\\', '/'))
    end

    # Returns the immediate child elements of the file(i.e. its Feature object).
    def contains
      []
    end

    def to_s
      ''
    end

  end
end
