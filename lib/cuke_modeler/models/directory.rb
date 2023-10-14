module CukeModeler

  # A class modeling a directory in a Cucumber suite.
  class Directory < Model


    # The feature file models contained by the modeled directory
    attr_accessor :feature_files

    # The directory models contained by the modeled directory
    attr_accessor :directories

    # The file path of the modeled directory
    attr_accessor :path


    # Creates a new Directory object and, if *directory_path* is provided,
    # populates the object.
    #
    # @example
    #   Directory.new
    #   Directory.new('some/directory/path')
    #
    # @param directory_path [String] The directory path that will be used to populate the model
    # @raise [ArgumentError] If *directory_path* is not a String
    # @return [Directory] A new Directory instance
    def initialize(directory_path = nil)
      @path = directory_path
      @feature_files = []
      @directories = []

      super(directory_path)
    end

    # Returns the name of the modeled directory.
    #
    # @example
    #   d = Directory.new('some/directory/foo')
    #   d.name  #=> 'foo'
    #
    # @return [String, nil] The name of the directory
    def name
      File.basename(@path.gsub('\\', '/')) if @path
    end

    # Returns the model objects that are children of this model. For a
    # Directory model, these would be any associated Directory and FeatureFile
    # models.
    #
    # @example
    #   directory.children
    #
    # @return [Array<Directory, FeatureFile>] A collection of child models
    def children
      @feature_files + @directories
    end

    # Returns a string representation of this model. For a Directory
    # model, this will be the path of the modeled directory.
    #
    # @example
    #   directory.to_s #=> 'some/directory/path'
    #
    # @return [String] A string representation of this model
    def to_s
      path.to_s
    end

    # See `Object#inspect`. Returns some basic information about the
    # object, including its class, object ID, and its most meaningful
    # attribute. For a Directory model, this will be the path of the
    # directory. If *verbose* is true, provides default Ruby inspection
    # behavior instead.
    #
    # @example
    #   directory.inspect
    #   directory.inspect(verbose: true)
    #
    # @param verbose [Boolean] Whether or not to return the full details of
    #   the object. Defaults to false.
    # @return [String] A string representation of this model
    def inspect(verbose: false)
      return super(verbose: verbose) if verbose

      "#{super.chop} @path: #{@path.inspect}>"
    end


    private


    def process_source(directory_path)
      raise(ArgumentError, "Unknown directory: #{directory_path.inspect}") unless File.exist?(directory_path)

      process_directory(directory_path)
    end

    def process_directory(directory_path)
      directory_data = { 'path'          => directory_path,
                         'directories'   => [],
                         'feature_files' => [] }

      entries = Dir.entries(directory_path)
      entries.delete '.'
      entries.delete '..'

      entries.each do |entry|
        entry = "#{directory_path}/#{entry}"

        # Ignore anything that isn't a directory or a feature file
        if File.directory?(entry)
          directory_data['directories'] << process_directory(entry)
        elsif entry =~ /\.feature$/
          directory_data['feature_files'] << process_feature_file(entry)
        end
      end


      directory_data
    end

    def process_feature_file(file_path)
      source_text = File.read(file_path)
      feature_file_data = Parsing.parse_text(source_text, file_path)

      feature_file_data.merge({ 'path' => file_path })
    end

    def populate_model(processed_directory_data)
      @path = processed_directory_data['path']

      processed_directory_data['directories'].each do |directory_data|
        @directories << build_child_model(Directory, directory_data)
      end

      processed_directory_data['feature_files'].each do |feature_file_data|
        @feature_files << build_child_model(FeatureFile, feature_file_data)
      end
    end

  end
end
