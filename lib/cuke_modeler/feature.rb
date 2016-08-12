module CukeModeler

  # A class modeling a Cucumber Feature.

  class Feature < Model

    include Parsed
    include Named
    include Described
    include Taggable
    include Sourceable


    # The Background object contained by the Feature
    attr_accessor :background

    # The Scenario and Outline objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source* is provided, populates the
    # object.
    def initialize(source_text = nil)
      @name = ''
      @description = ''
      @tags = []
      @tests = []

      super(source_text)

      if source_text
        parsed_feature_data = parse_source(source_text)
        populate_feature(self, parsed_feature_data)
      end
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

    # Returns the number of test cases contained in the feature.
    def test_case_count
      scenarios.count + outlines.reduce(0) { |outline_sum, outline|
        outline_sum += outline.examples.reduce(0) { |example_sum, example|
          example_sum += example.argument_rows.count
        }
      }
    end

    # Returns the model objects that belong to this model.
    def children
      models = tests + tags
      models << background if background

      models
    end

    # Returns gherkin representation of the feature.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "Feature:#{name_output_string}"
      text << "\n" + description_output_string unless description.empty?
      text << "\n\n" + background_output_string if background
      text << "\n\n" + tests_output_string unless tests.empty?

      text
    end


    private


    def parse_source(source_text)
      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_feature.feature')

      parsed_file.first
    end

    def background_output_string
      test_output_string(background)
    end

    def tests_output_string
      tests.collect { |test| test_output_string(test) }.join("\n\n")
    end

    def test_output_string(model)
      model.to_s.split("\n").collect { |line| line.empty? ? '' : "  #{line}" }.join("\n")
    end

  end
end
