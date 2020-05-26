# Have to at least load some version of the gem before which version of the gem has been loaded can
# be determined and the rest of the needed files can be loaded. The entry points vary across versions,
# so try them all until one of them works.
begin
  # Gherkin 2.x, 8.x
  require 'gherkin'
rescue LoadError
  begin
    require 'gherkin/parser'
  rescue LoadError
    # Gherkin 6.x, 7.x
    require 'gherkin/gherkin'
  end
end


# The *gherkin* gem loads differently and has different grammar rules across major versions. Parsing
# will be done with an 'adapter' appropriate to the version of the *gherkin* gem that has been activated.

gherkin_version = Gem.loaded_specs['gherkin'].version.version
gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i

case gherkin_major_version
  when 6, 7, 8
    require 'gherkin/dialect'
  when 3, 4, 5
    require 'gherkin/parser'
  when 2
    require 'stringio'
    require 'gherkin/formatter/json_formatter'
    require 'gherkin'
    require 'json'
    require 'multi_json'
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
          @dialects = Gem.loaded_specs['gherkin'].version.version[/^2\./] ? Gherkin::I18n::LANGUAGES : Gherkin::DIALECTS
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


      gherkin_version = Gem.loaded_specs['gherkin'].version.version
      gherkin_major_version = gherkin_version.match(/^(\d+)\./)[1].to_i

      case gherkin_major_version
        when 8
          # NOT A PART OF THE PUBLIC API
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin.from_source(filename, source_text, { :default_dialect => CukeModeler::Parsing.dialect, :include_gherkin_document => true }).to_a.map(&:to_hash)

            potential_error_message = messages.find { |message| message[:attachment] }
            gherkin_ast_message = messages.find { |message| message[:gherkinDocument] }

            if potential_error_message
              raise potential_error_message[:attachment][:data] if potential_error_message[:attachment][:data] =~ /expected.*got/
            end

            gherkin_ast_message[:gherkinDocument]
          end
        when 6, 7
          # NOT A PART OF THE PUBLIC API
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            messages = Gherkin::Gherkin.from_source(filename, source_text, { :default_dialect => CukeModeler::Parsing.dialect }).to_a.map(&:to_hash)

            potential_error_message = messages.find { |message| message[:attachment] }
            gherkin_ast_message = messages.find { |message| message[:gherkinDocument] }

            if potential_error_message
              raise potential_error_message[:attachment][:data] if potential_error_message[:attachment][:data] =~ /expected.*got/
            end

            gherkin_ast_message[:gherkinDocument]
          end
        when 3, 4, 5
          # todo - make these methods private?
          # NOT A PART OF THE PUBLIC API
          # The method to use for parsing Gherkin text
          # Filename isn't used by this version of Gherkin but keeping the parameter so that the calling method only has to know one method signature
          def parsing_method(source_text, _filename)
            Gherkin::Parser.new.parse(source_text)
          end
        when 2
          # NOT A PART OF THE PUBLIC API
          # The method to use for parsing Gherkin text
          def parsing_method(source_text, filename)
            io = StringIO.new
            formatter = Gherkin::Formatter::JSONFormatter.new(io)
            parser = Gherkin::Parser::Parser.new(formatter)
            parser.parse(source_text, filename, 0)
            formatter.done
            MultiJson.load(io.string)
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
