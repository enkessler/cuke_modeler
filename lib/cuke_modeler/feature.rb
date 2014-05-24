module CukeModeler

  # A class modeling a Cucumber Feature.

  class Feature < ModelElement

    include Named
    include Described
    include Taggable
    include Sourceable
    include Containing


    # The Background object contained by the Feature
    attr_accessor :background

    # The Scenario and Outline objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_feature = process_source(source)

      @name = ''
      @description = ''
      @tags = []
      @tests = []

      build_feature(parsed_feature) if parsed_feature
    end

    # Returns the scenarios contained in the feature.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outlines contained in the feature.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the immediate child elements of the feature (i.e. its Background,
    # Scenario, and Outline objects.
    def contains
      @background ? [@background] + @tests : @tests
    end


    # Returns gherkin representation of the feature.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Feature:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?

      text
    end


    private


    def parse_model(source_text)
      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first
    end

    def build_feature(parsed_feature)
      populate_source_line(parsed_feature)
      populate_tags(parsed_feature)
      populate_name(parsed_feature)
      populate_description(parsed_feature)
      populate_children(parsed_feature)
    end

    def populate_children(parsed_feature)
      elements = parsed_feature['elements']

      if elements
        elements.each do |element|
          case element['keyword']
            when 'Scenario'
              @tests << build_child_element(Scenario, element)
            when 'Scenario Outline'
              @tests << build_child_element(Outline, element)
            when 'Background'
              @background = build_child_element(Background, element)
            else
              raise(ArgumentError, "Unknown keyword: #{element['keyword']}")
          end
        end
      end
    end

  end
end
