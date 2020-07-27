module CukeModeler

  # A class modeling a feature in a Cucumber suite.

  class Feature < Model

    include Parsed
    include Named
    include Described
    include Taggable
    include Sourceable


    # The keyword for the feature
    attr_accessor :keyword

    # The Background object contained by the Feature
    attr_accessor :background

    # The Rule objects contained by the Feature
    attr_accessor :rules

    # The Scenario and Outline objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source_text* is provided, populates the
    # object.
    def initialize(source_text = nil)
      @tags = []
      @rules = []
      @tests = []

      super(source_text)

      if source_text
        parsed_feature_data = parse_source(source_text)
        populate_feature(self, parsed_feature_data)
      end
    end

    # Returns *true* if the feature contains a background, *false* otherwise.
    def has_background?
      !@background.nil?
    end

    # Returns the scenario models contained in the feature.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outline models contained in the feature.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the number of test cases contained in the feature. A test case is a
    # single set of test values, such as an individual scenario or one example row
    # of an outline.
    def test_case_count
      scenarios.count + outlines.reduce(0) { |outline_sum, outline|
        outline_sum += outline.examples.reduce(0) { |example_sum, example|
          example_sum += example.argument_rows.count
        }
      }
    end

    # Returns the model objects that belong to this model.
    def children
      models = rules + tests + tags
      models << background if background

      models
    end

    # Returns a string representation of this model. For a feature model,
    # this will be Gherkin text that is equivalent to the feature being modeled.
    def to_s
      text = ''

      text << tag_output_string + "\n" unless tags.empty?
      text << "#{@keyword}:#{name_output_string}"
      text << "\n" + description_output_string unless (description.nil? || description.empty?)
      text << "\n\n" + background_output_string if background
      text << "\n\n" + tests_output_string unless tests.empty?
      text << "\n\n" + rules_output_string unless rules.empty?

      text
    end


    private


    def parse_source(source_text)
      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_feature.feature')

      parsed_file['feature']
    end

    def background_output_string
      child_element_output_string(background)
    end

    def tests_output_string
      tests.collect { |test| child_element_output_string(test) }.join("\n\n")
    end

    def rules_output_string
      rules.collect { |rule| child_element_output_string(rule) }.join("\n\n")
    end

    def child_element_output_string(model)
      model.to_s.split("\n").collect { |line| line.empty? ? '' : "  #{line}" }.join("\n")
    end

  end
end
