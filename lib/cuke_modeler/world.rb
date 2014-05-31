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

      # Returns all tags found in the passed container.
      def tags_in(container)
        Array.new.tap { |accumulated_tags| collect_all_in(:tags, container, accumulated_tags) }
      end

      # Returns all tag elements found in the passed container.
      def tag_elements_in(container)
        Array.new.tap { |accumulated_tag_elements| collect_all_in(:tag_elements, container, accumulated_tag_elements) }
      end

      # Returns all directories found in the passed container.
      def directories_in(container)
        Array.new.tap { |accumulated_directories| collect_all_in(:directories, container, accumulated_directories) }
      end

      # Returns all feature files found in the passed container.
      def feature_files_in(container)
        Array.new.tap { |accumulated_files| collect_all_in(:feature_files, container, accumulated_files) }
      end

      # Returns all features found in the passed container.
      def features_in(container)
        Array.new.tap { |accumulated_features| collect_all_in(:features, container, accumulated_features) }
      end

      # Returns all tests found in the passed container.
      def tests_in(container)
        Array.new.tap { |accumulated_tests| collect_all_in(:tests, container, accumulated_tests) }
      end

      # Returns all steps found in the passed container.
      def steps_in(container)
        Array.new.tap { |accumulated_steps| collect_all_in(:steps, container, accumulated_steps) }
      end

      # Returns all undefined steps found in the passed container.
      def undefined_steps_in(container)
        all_steps = steps_in(container)

        all_steps.select { |step| !World.loaded_step_patterns.any? { |pattern| step.base =~ Regexp.new(pattern) } }
      end

      # Returns all defined steps found in the passed container.
      def defined_steps_in(container)
        all_steps = steps_in(container)

        all_steps.select { |step| World.loaded_step_patterns.any? { |pattern| step.base =~ Regexp.new(pattern) } }
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

      # Recursively gathers all things of the given type found in the passed container.
      def collect_all_in(type_of_thing, container, accumulated_things)
        accumulated_things.concat container.send(type_of_thing) if container.respond_to?(type_of_thing)

        if container.respond_to?(:contains)
          container.contains.each do |child_container|
            collect_all_in(type_of_thing, child_container, accumulated_things)
          end
        end
      end

    end
  end
end
