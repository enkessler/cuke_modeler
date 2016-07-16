# The 'gherkin' gem loads differently and has different grammar rules across major versions. Parsing 
# will be with an 'adapter' appropriate to the version of the 'gherkin' gem that has been activated.


# todo - add this back in so that we know the gherkin gem has actually been loaded before trying to check which version has been loaded
# # The 'gherkin' gem loads differently depending across versions. Try the old one first and then the new one
# begin
#   require 'gherkin'
# rescue LoadError => e
#   require 'gherkin/parser'
# end


case
  when Gem.loaded_specs['gherkin'].version.version[/^4/]
    require 'gherkin/parser'
    require 'cuke_modeler/adapters/gherkin_4_adapter'


    def parsing_method(source_text, _filename)
      Gherkin::Parser.new.parse(source_text)
    end

    def adapter_class
      CukeModeler::Gherkin4Adapter
    end

  when Gem.loaded_specs['gherkin'].version.version[/^3/]
    require 'gherkin/parser'
    require 'cuke_modeler/adapters/gherkin_3_adapter'


    def parsing_method(source_text, _filename)
      Gherkin::Parser.new.parse(source_text)
    end

    def adapter_class
      CukeModeler::Gherkin3Adapter
    end

  else # Assume version 2.x
    require 'stringio'
    require 'gherkin/formatter/json_formatter'
    require 'gherkin'
    require 'json'
    require 'multi_json'
    require 'cuke_modeler/adapters/gherkin_2_adapter'


    def parsing_method(source_text, filename)
      io = StringIO.new
      formatter = Gherkin::Formatter::JSONFormatter.new(io)
      parser = Gherkin::Parser::Parser.new(formatter)
      parser.parse(source_text, filename, 0)
      formatter.done
      MultiJson.load(io.string)
    end

    def adapter_class
      CukeModeler::Gherkin2Adapter
    end

end


module CukeModeler

  # A module providing source text parsing functionality.

  module Parsing

    class << self

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
  end
end
