module CukeModeler

  # A class modeling a feature file in a Cucumber suite.
  class FeatureFile < Model

    include Parsed


    # The comment models contained by the modeled feature file
    attr_accessor :comments

    # The feature model contained by the modeled feature file
    attr_accessor :feature

    # The file path of the modeled feature file
    attr_accessor :path


    # Creates a new FeatureFile object and, if *file_path* is provided,
    # populates the object.
    #
    # @example
    #   FeatureFile.new
    #   FeatureFile.new('path/to/some.feature')
    #
    # @param file_path [String] The file path that will be used to populate the model
    # @raise [ArgumentError] If *file_path* is not a String
    # @return [FeatureFile] A new FeatureFile instance
    def initialize(file_path = nil)
      @path = file_path
      @comments = []

      super(file_path)
    end

    # Returns the name of the modeled feature file.
    #
    # @example
    #   f = FeatureFile.new('path/to/some.feature')
    #   f.name  #=> 'some.feature'
    #
    # @return [String] The name of the file
    def name
      File.basename(@path.gsub('\\', '/')) if @path
    end

    # Returns the model objects that are children of this model. For a
    # FeatureFile model, this would be any associated Feature model.
    #
    # @example
    #   feature_file.children
    #
    # @return [Array<Feature>] A collection of child models
    def children
      @feature ? [@feature] : []
    end

    # Returns a string representation of this model. For a feature file
    # model, this will be the path of the modeled feature file.
    #
    # @example
    #   feature_file.to_s #=> 'path/to/some.feature'
    #
    # @return [String] A string representation of this model
    def to_s
      path.to_s
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a feature file model, this will be the path of
    # the feature file. If *verbose* is true, provides default Ruby
    # inspection behavior instead.
    #
    # @example
    #   feature_file.inspect
    #   feature_file.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @path: #{@path.inspect}>"
    end


    private


    def process_source(file_path)
      raise(ArgumentError, "Unknown file: #{file_path.inspect}") unless File.exist?(file_path)

      source_text       = File.read(file_path)
      feature_file_data = Parsing.parse_text(source_text, file_path)

      feature_file_data.merge({ 'path' => file_path })
    end

    def populate_model(processed_feature_file_data)
      populate_parsing_data(processed_feature_file_data)
      @path = processed_feature_file_data['path']

      if processed_feature_file_data['feature']
        @feature = build_child_model(Feature, processed_feature_file_data['feature'])
      end

      processed_feature_file_data['comments'].each do |comment_data|
        @comments << build_child_model(Comment, comment_data)
      end
    end

  end
end
