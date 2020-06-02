# Have to at least load some version of the gem before which version of the gem has been loaded can
# be determined and the rest of the needed files can be loaded. The entry points vary across versions,
# so try them all until one of them works.
begin
  # Gherkin 9.x
  require 'gherkin'
rescue LoadError => e
  # Add other entry points again if things change again
  raise e
end


# The *cucumber-gherkin* gem loads differently and has different grammar rules across major versions. Parsing
# will be done with an 'adapter' appropriate to the version of the *cucumber-gherkin* gem that has been activated.

gherkin_version = Gem.loaded_specs['cucumber-gherkin'].version.version
gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i

case gherkin_major_version
  when 9, 10
    # Currently nothing else to load beyond the entry point to the gem
  else
    raise("Unknown Gherkin version: '#{gherkin_version}'")
end

require "cuke_modeler/adapters/gherkin_#{gherkin_major_version}_adapter"


module CukeModeler

  # A module providing source text parsing functionality.

  module Parsing

    class << self

      # The dialect that will be used to parse snippets of Gherkin text
      attr_writer :dialect


      # The dialect that will be used to parse snippets of Gherkin text
      def dialect
        @dialect || 'en'
      end

      # The dialects currently known by the gherkin gem
      def dialects
        unless @dialects
          @dialects = Gherkin::DIALECTS
        end

        @dialects
      end

      # Parses the Cucumber feature given in *source_text* and returns an array
      # containing the hash representation of its logical structure.
      def parse_text(source_text, filename = 'cuke_modeler_fake_file.feature')
        raise(ArgumentError, "Text to parse must be a String but got #{source_text.class}") unless source_text.is_a?(String)

        begin
          parsed_result = parsing_method(source_text, filename)
        rescue => e
          raise(ArgumentError, "Error encountered while parsing '#{filename}'\n#{e.class} - #{e.message}")
        end

        adapter_class.new.adapt(parsed_result)
      end


      gherkin_version = Gem.loaded_specs['cucumber-gherkin'].version.version
      gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i

      case gherkin_major_version
        when 9,10
          # todo - make these methods private?
          # NOT A PART OF THE PUBLIC API
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename, source_text, { :include_gherkin_document => true }).to_a.map(&:to_hash)

            potential_error_message = messages.find { |message| message[:attachment] }
            gherkin_ast_message = messages.find { |message| message[:gherkin_document] }

            if potential_error_message
              raise potential_error_message[:attachment][:text] if potential_error_message[:attachment][:text] =~ /expected.*got/
            end

            gherkin_ast_message[:gherkin_document]
          end
        else
          raise("Unknown Gherkin version: '#{gherkin_version}'")
      end

      # NOT A PART OF THE PUBLIC API
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
      get_word(Parsing.dialects[Parsing.dialect]['scenarioOutline'] || Parsing.dialects[Parsing.dialect]['scenario_outline'])
    end

    def dialect_step_keyword
      get_word(Parsing.dialects[Parsing.dialect]['given'])
    end

    def get_word(word_set)
      word_set = word_set.is_a?(Array) ? word_set : word_set.split('|')

      word_set.first
    end

  end
end
