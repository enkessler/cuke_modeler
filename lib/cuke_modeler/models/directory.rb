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
    def initialize(directory_path = nil)
      @path = directory_path
      @feature_files = []
      @directories = []

      super(directory_path)

      return unless directory_path
      raise(ArgumentError, "Unknown directory: #{directory_path.inspect}") unless File.exist?(directory_path)

      processed_directory_data = process_directory(directory_path)
      populate_directory(self, processed_directory_data)
    end

    # Returns the name of the modeled directory.
    def name
      File.basename(@path.gsub('\\', '/')) if @path
    end

    # Returns the model objects that belong to this model.
    def children
      @feature_files + @directories
    end

    # Returns a string representation of this model. For a directory
    # model, this will be the path of the modeled directory.
    def to_s
      path.to_s
    end


    private


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
      source_text = IO.read(file_path)

      feature_file_data = Parsing.parse_text(source_text, file_path)
      feature_file_data = feature_file_data.merge({ 'path' => file_path })

      feature_file_data
    end

  end
end
