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

    # The step's arguments
    attr_accessor :arguments


    # Creates a new Step object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      @arguments = []

      parsed_step = process_source(source)

      build_step(parsed_step) if parsed_step
    end

    # Sets the delimiter that will be used by default when determining the
    # boundaries of step arguments.
    def delimiter=(new_delimiter)
      self.left_delimiter = new_delimiter
      self.right_delimiter = new_delimiter
    end

    # Returns the delimiter that is used to mark the beginning of a step
    # argument.
    def left_delimiter
      @left_delimiter || World.left_delimiter
    end

    # Sets the left delimiter that will be used by default when determining
    # step arguments.
    def left_delimiter=(new_delimiter)
      @left_delimiter = new_delimiter
    end

    # Returns the delimiter that is used to mark the end of a step
    # argument.
    def right_delimiter
      @right_delimiter || World.right_delimiter
    end

    # Sets the right delimiter that will be used by default when determining
    # step arguments.
    def right_delimiter=(new_delimiter)
      @right_delimiter = new_delimiter
    end

    # Returns true if the two steps have the same text, minus any keywords
    # and arguments, and false otherwise.
    def ==(other_step)
      return false unless other_step.respond_to?(:step_text)

      left_step = step_text(:with_keywords => false, :with_arguments => false)
      right_step = other_step.step_text(:with_keywords => false, :with_arguments => false)

      left_step == right_step
    end

    # Deprecated
    #
    # Returns the entire text of the step. Options can be set to selectively
    # exclude certain portions of the text. *left_delimiter* and *right_delimiter*
    # are used to determine which parts of the step are arguments.
    #
    #  a_step = CukeModeler::Step.new("Given *some* step with a block:\n|block line 1|\n|block line 2|")
    #
    #  a_step.step_text
    #  #=> ['Given *some* step with a block:', '|block line 1|', '|block line 2|']
    #  a_step.step_text(:with_keywords => false)
    #  #=> ['*some* step with a block:', '|block line 1|', '|block line 2|']
    #  a_step.step_text(:with_arguments => false, :left_delimiter => '*', :right_delimiter => '*')
    #  #=> ['Given ** step with a block:']
    #  a_step.step_text(:with_keywords => false, :with_arguments => false, :left_delimiter => '-', :right_delimiter => '-'))
    #  #=> ['*some* step with a block:']
    #
    def step_text(options = {})
      options = {:with_keywords => true,
                 :with_arguments => true,
                 :left_delimiter => self.left_delimiter,
                 :right_delimiter => self.right_delimiter}.merge(options)

      final_step = []
      step_text = ''

      step_text += "#{@keyword} " if options[:with_keywords]

      if options[:with_arguments]
        step_text += @base
        final_step << step_text
        final_step.concat(rebuild_block_text(@block)) if @block
      else
        step_text += stripped_step(@base, options[:left_delimiter], options[:right_delimiter])
        final_step << step_text
      end

      final_step
    end

    # Populates the step's arguments based on the step's text and some method of
    # determining which parts of the text are arguments. Methods include using
    # a regular expression and using the step's delimiters.
    def scan_arguments(*how)
      if how.count == 1
        pattern = how.first
      else
        left_delimiter = how[0] || self.left_delimiter
        right_delimiter = how[1] || self.right_delimiter

        return [] unless left_delimiter && right_delimiter

        pattern = Regexp.new(Regexp.escape(left_delimiter) + '(.*?)' + Regexp.escape(right_delimiter))
      end

      @arguments = @base.scan(pattern).flatten
    end

    # Returns a gherkin representation of the step.
    def to_s
      text = "#{keyword} #{base}"
      text << "\n" + block.to_s.split("\n").collect { |line| "  #{line}" }.join("\n") if block

      text
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_step(source)
        else
          source
      end
    end

    def parse_step(source_text)
      base_file_string = "Feature: Fake feature to parse\nScenario:\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text, 'cuke_modeler_stand_alone_step.feature')

      parsed_file.first['elements'].first['steps'].first
    end

    def build_step(step)
      populate_base(step)
      populate_block(step)
      populate_keyword(step)
      populate_element_source_line(step)
      populate_raw_element(step)

      scan_arguments
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

    # Returns the step string minus any arguments based on the given delimiters.
    def stripped_step(step, left_delimiter, right_delimiter)
      unless left_delimiter.nil? || right_delimiter.nil?
        pattern = Regexp.new(Regexp.escape(left_delimiter) + '.*?' + Regexp.escape(right_delimiter))
        step = step.gsub(pattern, left_delimiter + right_delimiter)
      end

      step
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

    def rebuild_block_text(blok)
      blok.rows.collect { |row| "|#{row.cells.join('|')}|" }
    end

  end
end
