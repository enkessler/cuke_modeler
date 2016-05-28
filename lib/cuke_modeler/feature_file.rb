module CukeModeler

  # A class modeling a Cucumber .feature file.

  class FeatureFile < ModelElement

    include Containing


    # The Feature object contained by the FeatureFile
    attr_accessor :feature

    # The file path of the FeatureFile
    attr_accessor :path


    # Creates a new FeatureFile object and, if *file_parsed* is provided,
    # populates the object.
    def initialize(file = nil)
      @path = file

      if file
        raise(ArgumentError, "Unknown file: #{file.inspect}") unless File.exists?(file)

        parsed_file = parse_file(file)

        build_file(parsed_file)
      end
    end

    # Returns the name of the file.
    def name
      File.basename(@path.gsub('\\', '/')) if @path
    end

    # Returns the immediate child elements of the file(i.e. its Feature object).
    def children
      [@feature]
    end

    # Returns the path of the feature file.
    def to_s
      path.to_s
    end


    private


    def parse_file(file_to_parse)
      source_text = IO.read(file_to_parse)

      Parsing::parse_text(source_text, file_to_parse)
    end

    def build_file(parsed_file)
      unless parsed_file.empty?
        @feature = build_child_element(Feature, parsed_file.first)
      end
    end

  end
end
