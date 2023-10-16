# rubocop:disable Metrics/ModuleLength - Just not going to worry about this

# Have to at least load some version of the gem before which version of the gem has been loaded can
# be determined and the rest of the needed files can be loaded.
require 'gherkin'


# The *cucumber-gherkin* has different grammar rules across major versions. Parsing will be done with
# an 'adapter' appropriate to the version of the *cucumber-gherkin* gem that has been activated.
gherkin_version = Gem.loaded_specs['cucumber-gherkin'].version.version
gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i
supported_gherkin_versions = (9..27)

raise("Unknown Gherkin version: '#{gherkin_version}'") unless supported_gherkin_versions.include?(gherkin_major_version)

require "cuke_modeler/adapters/gherkin_#{gherkin_major_version}_adapter"


module CukeModeler

  # A module providing source text parsing functionality.
  module Parsing

    class << self

      # The dialect that will be used to parse snippets of Gherkin text
      attr_writer :dialect


      # The dialect that will be used to parse snippets of Gherkin text
      #
      # @example
      #   Parsing.dialect
      #
      # @return [String] The current dialect. Defaults to 'en'.
      def dialect
        @dialect || 'en'
      end

      # The dialects currently known by the cucumber-gherkin gem. See *Gherkin::DIALECTS*.
      #
      # @example
      #   Parsing.dialects
      #
      # @return [Hash] The dialect data
      def dialects
        Gherkin::DIALECTS
      end

      # Parses the Cucumber feature given in *source_text* and returns a Hash representation of
      # its logical structure. This is a standardized AST that should remain consistent across
      # different versions of `cucumber-gherkin`
      #
      # @example
      #   Parsing.parse_text('Feature: Some feature')
      #   Parsing.parse_text('Feature: Some feature', 'my.feature')
      #
      # @param source_text [String] The Gherkin text to parse
      # @param filename [String] The file name associated with the parsed text. Used for error messages.
      # @raise [ArgumentError] If *source_text* is not a String
      # @raise [ArgumentError] If *source_text* does not parse cleanly
      # @return [Hash] An AST of the text
      def parse_text(source_text, filename = 'cuke_modeler_fake_file.feature')
        unless source_text.is_a?(String)
          raise(ArgumentError, "Text to parse must be a String but got #{source_text.class}")
        end

        begin
          parsed_result = parsing_method(source_text.encode('UTF-8'), filename)
        rescue => e
          raise(ArgumentError, "Error encountered while parsing '#{filename}'\n#{e.class} - #{e.message}")
        end

        adapter_class.new.adapt(parsed_result)
      end


      private


      gherkin_version = Gem.loaded_specs['cucumber-gherkin'].version.version
      gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i

      # Previous versions of the gem had more variation between their parsing methods and so it was more
      # understandable to have different methods instead of a single method with lots of conditional statements
      # inside of it, so I'm leaving this here in case it changes again
      # rubocop:disable Lint/DuplicateMethods
      case gherkin_major_version
        when 20, 21, 22, 23, 24, 25, 26, 27
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename,
                                           source_text,
                                           { include_gherkin_document: true })
                              .to_a

            error_message = messages.find(&:parse_error)
            gherkin_ast_message = messages.find(&:gherkin_document)

            raise error_message.parse_error.message if error_message

            gherkin_ast_message.gherkin_document
          end
        when 19
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename,
                                           source_text,
                                           { include_gherkin_document: true })
                              .to_a.map(&:to_hash)

            error_message = messages.find { |message| message[:parseError] }
            gherkin_ast_message = messages.find { |message| message[:gherkinDocument] }

            raise error_message[:parseError][:message] if error_message

            gherkin_ast_message[:gherkinDocument]
          end
        when 13, 14, 15, 16, 17, 18
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename,
                                           source_text,
                                           { include_gherkin_document: true })
                              .to_a.map(&:to_hash)

            error_message = messages.find { |message| message[:parse_error] }
            gherkin_ast_message = messages.find { |message| message[:gherkin_document] }

            raise error_message[:parse_error][:message] if error_message

            gherkin_ast_message[:gherkin_document]
          end
        when 12
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename,
                                           source_text,
                                           { include_gherkin_document: true })
                              .to_a.map(&:to_hash)

            potential_error_message = messages.find { |message| message[:attachment] }
            gherkin_ast_message = messages.find { |message| message[:gherkin_document] }

            if potential_error_message && potential_error_message[:attachment][:body] =~ /expected.*got/
              raise potential_error_message[:attachment][:body]
            end

            gherkin_ast_message[:gherkin_document]
          end
        when 9, 10, 11
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename,
                                           source_text,
                                           { include_gherkin_document: true })
                              .to_a.map(&:to_hash)

            potential_error_message = messages.find { |message| message[:attachment] }
            gherkin_ast_message = messages.find { |message| message[:gherkin_document] }

            if potential_error_message && potential_error_message[:attachment][:text] =~ /expected.*got/
              raise potential_error_message[:attachment][:text]
            end

            gherkin_ast_message[:gherkin_document]
          end
      end
      # rubocop:enable Lint/DuplicateMethods

      # The adapter to use when converting an AST to a standard internal shape
      define_method('adapter_class') do
        CukeModeler.const_get("Gherkin#{gherkin_major_version}Adapter")
      end

    end


    private


    def dialect_feature_keyword
      get_word(Parsing.dialects[Parsing.dialect]['feature'])
    end

    def dialect_scenario_keyword
      get_word(Parsing.dialects[Parsing.dialect]['scenario'])
    end

    def dialect_outline_keyword
      get_word(Parsing.dialects[Parsing.dialect]['scenarioOutline'] ||
                 Parsing.dialects[Parsing.dialect]['scenario_outline'])
    end

    def dialect_step_keyword
      get_word(Parsing.dialects[Parsing.dialect]['given'])
    end

    def get_word(word_set)
      word_set = word_set.split('|') unless word_set.is_a?(Array)

      word_set.first
    end

  end
end

# rubocop:enable Metrics/ModuleLength
