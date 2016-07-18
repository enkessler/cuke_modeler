module CukeModeler

  # A class modeling a Cucumber .feature file.

  class FeatureFile < ModelElement


    # The feature object contained by the modeled feature file
    attr_accessor :feature

    # The file path of the modeled feature file
    attr_accessor :path


    # Creates a new FeatureFile object and, if *file_parsed* is provided,
    # populates the object.
    def initialize(file_path = nil)
      @path = file_path

      super(file_path)

      if file_path
        raise(ArgumentError, "Unknown file: #{file_path.inspect}") unless File.exists?(file_path)

        processed_feature_file_data = process_feature_file(file_path)
        populate_featurefile(self, processed_feature_file_data)
      end

    end

    # Returns the name of the modeled feature file.
    def name
      File.basename(@path.gsub('\\', '/')) if @path
    end

    # Returns the model objects that belong to this model.
    def children
      [@feature]
    end

    # Returns the path of the modeled feature file.
    def to_s
      path.to_s
    end


    private


    def process_feature_file(file_path)
      feature_file_data = {'path' => file_path}

      source_text = IO.read(file_path)
      feature = Parsing::parse_text(source_text, file_path).first

      feature_file_data['feature'] = feature


      feature_file_data
    end

  end
end
