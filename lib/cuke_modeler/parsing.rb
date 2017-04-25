module CukeModeler

  # A module providing source text parsing functionality.

  module Parsing


    # Have to at least load some version of the gem before which version of the gem has been loaded can
    # be determined and the rest of the needed files can be loaded. Try the old one first and then the
    # new one.
    begin
      require 'gherkin'
    rescue LoadError
      require 'gherkin/parser'
    end


    # The *gherkin* gem loads differently and has different grammar rules across major versions. Parsing
    # will be done with an 'adapter' appropriate to the version of the *gherkin* gem that has been activated.

    case Gem.loaded_specs['gherkin'].version.version
      when /^4\./
        require 'gherkin/parser'
        require 'cuke_modeler/adapters/gherkin_4_adapter'


        # todo - make these methods private?
        def self.parsing_method(source_text, _filename)
          Gherkin::Parser.new.parse(source_text)
        end

        def self.adapter_class
          CukeModeler::Gherkin4Adapter
        end

      when /^3\./
        require 'gherkin/parser'
        require 'cuke_modeler/adapters/gherkin_3_adapter'


        def self.parsing_method(source_text, _filename)
          Gherkin::Parser.new.parse(source_text)
        end

        def self.adapter_class
          CukeModeler::Gherkin3Adapter
        end

      else # Assume version 2.x
        require 'stringio'
        require 'gherkin/formatter/json_formatter'
        require 'gherkin'
        require 'json'
        require 'multi_json'
        require 'cuke_modeler/adapters/gherkin_2_adapter'


        def self.parsing_method(source_text, filename)
          io = StringIO.new
          formatter = Gherkin::Formatter::JSONFormatter.new(io)
          parser = Gherkin::Parser::Parser.new(formatter)
          parser.parse(source_text, filename, 0)
          formatter.done
          MultiJson.load(io.string)
        end

        def self.adapter_class
          CukeModeler::Gherkin2Adapter
        end

    end


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

        adapted_result = adapter_class.new.adapt(parsed_result)


        adapted_result
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
