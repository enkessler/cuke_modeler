module CukeModeler

  # A class modeling a Cucumber Feature.

  class Step < ModelElement

    include Containing
    include Sourceable
    include Raw


    # The step's keyword
    attr_accessor :keyword

    # The base text of the step
    attr_accessor :base

    # The step's passed block
    attr_accessor :block


    # Creates a new Step object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_step = process_source(source)

      build_step(parsed_step) if parsed_step
    end

    # Returns true if the two steps have the same base text (i.e. minus any keyword, 
    # table, or doc string
    def ==(other_step)
      return false unless other_step.respond_to?(:base)

      base == other_step.base
    end

    # Returns the model objects that belong to this model.
    def children
      [block]
    end

    # Returns a gherkin representation of the step.
    def to_s
      text = "#{keyword} #{base}"
      text << "\n" + block.to_s.split("\n").collect { |line| "  #{line}" }.join("\n") if block

      text
    end


    private


    def parse_model(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_step.feature')

      parsed_file.first['elements'].first['steps'].first
    end

    def build_step(step)
      populate_base(step)
      populate_block(step)
      populate_keyword(step)
      populate_source_line(step)
      populate_raw_element(step)
    end

    def populate_base(step)
      @base = step['name']
    end

    def populate_block(step)
      @block = build_block(step)
    end

    def populate_keyword(step)
      @keyword = step['keyword'].strip
    end

    def build_block(step)
      case
        when step['rows']
          @block = build_child_element(Table, step['rows'])
        when step['doc_string']
          @block = build_child_element(DocString, step['doc_string'])
        else
          @block = nil
      end

      @block
    end

  end
end
