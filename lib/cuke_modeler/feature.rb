module CukeModeler

  # A class modeling a Cucumber Feature.

  class Feature < FeatureElement

    include Taggable
    include Containing


    # The Background object contained by the Feature
    attr_accessor :background

    # The TestElement objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_feature = process_source(source)

      super(parsed_feature)

      @tags = []
      @tag_elements = []
      @tests = []

      build_feature(parsed_feature) if parsed_feature
    end

    # Returns true if the feature contains a background, false otherwise.
    def has_background?
      !@background.nil?
    end

    # Returns the scenarios contained in the feature.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outlines contained in the feature.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the number of scenarios contained in the feature.
    def scenario_count
      scenarios.count
    end

    # Returns the number of outlines contained in the feature.
    def outline_count
      outlines.count
    end

    # Returns the number of tests contained in the feature.
    def test_count
      @tests.count
    end

    # Returns the number of test cases contained in the feature.
    def test_case_count
      scenario_count + outlines.reduce(0) { |outline_sum, outline|
        outline_sum += outline.examples.reduce(0) { |example_sum, example|
          example_sum += example.rows.count
        }
      }
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
      text << "\n" + description_output_string unless description_text.empty?
      text << "\n\n" + background_output_string if background
      text << "\n\n" + tests_output_string unless tests.empty?

      text
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_feature(source)
        else
          source
      end
    end

    def parse_feature(source_text)
      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_feature.feature')

      parsed_file.first
    end

    def build_feature(parsed_feature)
      populate_element_tags(parsed_feature)
      populate_feature_elements(parsed_feature)
    end

    def populate_feature_elements(parsed_feature)
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

    def background_output_string
      test_element_output_string(background)
    end

    def tests_output_string
      tests.collect { |test| test_element_output_string(test) }.join("\n\n")
    end

    def test_element_output_string(test_element)
      test_element.to_s.split("\n").collect { |line| line.empty? ? '' : "  #{line}" }.join("\n")
    end

  end
end
