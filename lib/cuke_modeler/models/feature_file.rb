module CukeModeler

  # A class modeling a feature file in a Cucumber suite.

  class FeatureFile < Model


    # The feature model contained by the modeled feature file
    attr_accessor :feature

    # The file path of the modeled feature file
    attr_accessor :path


    # Creates a new FeatureFile object and, if *file_path* is provided,
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
      @feature ? [@feature] : []
    end

    # Returns a string representation of this model. For a feature file
    # model, this will be the path of the modeled feature file.
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
