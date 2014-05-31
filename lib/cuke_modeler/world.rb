module CukeModeler

# A module providing suite level analysis functionality.

  module World

    # A placeholder string used to mark 'dirty' portions of input strings
    SANITARY_STRING = '___SANITIZED_BY_CUCUMBER_ANALYTICS___'

    # A pattern that matches a Cucumber step keyword
    STEP_DEF_KEYWORD_PATTERN = '(?:Given|When|Then|And|But)'

    # A pattern that matches a 'clean' regular expression
    REGEX_PATTERN_STRING = '\/[^\/]*\/'

    # A pattern that matches a step definition declaration line
    STEP_DEF_LINE_PATTERN = /^\s*#{World::STEP_DEF_KEYWORD_PATTERN}\s*\(?\s*#{REGEX_PATTERN_STRING}\s*\)?/

    # A pattern that captures the regular expression portion of a step definition declaration line
    STEP_DEF_PATTERN_CAPTURE_PATTERN = /^\s*#{World::STEP_DEF_KEYWORD_PATTERN}\s*\(?\s*(#{REGEX_PATTERN_STRING})\s*\)?/


    class << self

      # Returns the left delimiter, which is used to mark the beginning of a step
      # argument.
      def left_delimiter
        @left_delimiter
      end

      # Sets the left delimiter that will be used by default when determining
      # step arguments.
      def left_delimiter=(new_delimiter)
        @left_delimiter = new_delimiter
      end

      # Returns the right delimiter, which is used to mark the end of a step
      # argument.
      def right_delimiter
        @right_delimiter
      end

      # Sets the right delimiter that will be used by default when determining
      # step arguments.
      def right_delimiter=(new_delimiter)
        @right_delimiter = new_delimiter
      end

      # Sets the delimiter that will be used by default when determining the
      # boundaries of step arguments.
      def delimiter=(new_delimiter)
        self.left_delimiter = new_delimiter
        self.right_delimiter = new_delimiter
      end

      # Loads the step patterns contained in the given file into the World.
      def load_step_file(file_path)
        File.open(file_path, 'r') do |file|
          file.readlines.each do |line|
            if step_def_line?(line)
              the_reg_ex = extract_regular_expression(line)
              loaded_step_patterns << the_reg_ex
            end
          end
        end
      end

      # Loads the step pattern into the World.
      def load_step_pattern(pattern)
        loaded_step_patterns << pattern
      end

      # Returns the step patterns that have been loaded into the World.
      def loaded_step_patterns
        @defined_expressions ||= []
      end

      # Clears the step patterns that have been loaded into the World.
      def clear_step_patterns
        @defined_expressions = []
      end


      private


      # Make life easier by ensuring that the only forward slashes in the
      # regular expression are the important ones.
      def sanitize_line(line)
        line.gsub('\/', SANITARY_STRING)
      end

      # And be sure to restore the line to its original state.
      def desanitize_line(line)
        line.gsub(SANITARY_STRING, '\/')
      end

      # Returns whether or not the passed line is a step pattern.
      def step_def_line?(line)
        !!(sanitize_line(line) =~ STEP_DEF_LINE_PATTERN)
      end

      # Returns the regular expression portion of a step pattern line.
      def extract_regular_expression(line)
        line = desanitize_line(sanitize_line(line).match(STEP_DEF_PATTERN_CAPTURE_PATTERN)[1])
        line = line.slice(1..(line.length - 2))

        Regexp.new(line)
      end

    end
  end
end
