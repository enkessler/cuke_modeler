module CukeModeler

  # A class modeling an basic element of a feature.

  class FeatureElement

    include Sourceable
    include Raw
    include Nested


    # The name of the FeatureElement
    attr_accessor :name

    # Deprecated
    #
    # The description of the FeatureElement
    attr_accessor :description

    # The description of the FeatureElement
    attr_accessor :description_text


    # Creates a new FeatureElement object and, if *parsed_element* is provided,
    # populates the object.
    def initialize(parsed_element = nil)
      @name = ''
      @description = []
      @description_text = ''

      build_feature_element(parsed_element) if parsed_element
    end


    private


    def build_feature_element(parsed_element)
      populate_feature_element_name(parsed_element)
      populate_feature_element_description(parsed_element)
      populate_element_source_line(parsed_element)
      populate_raw_element(parsed_element)
    end

    def populate_feature_element_name(parsed_element)
      @name = parsed_element['name']
    end

    def populate_feature_element_description(parsed_element)
      @description_text = parsed_element['description']
      @description = parsed_element['description'].split("\n").collect { |line| line.strip }
      @description.delete('')
    end

    def name_output_string
      name.empty? ? '' : " #{name}"
    end

    def description_output_string
      text = ''

      unless description_text.empty?
        description_lines = description_text.split("\n")

        text << "  \n" if description_lines.first =~ /\S/
        text << description_lines.collect { |line| "  #{line}" }.join("\n")
      end

      text
    end

  end
end
