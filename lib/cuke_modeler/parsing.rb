# The 'gherkin' gem loads differently depending across versions. Try the old one first and then the new one
begin
  require 'gherkin'
rescue LoadError => e
  require 'gherkin/parser'
end

# Parsing will be with an 'adapter' appropriate to the version of the 'gherkin' gem that has been activated
case
  when Gem.loaded_specs['gherkin'].version.version[/^4/]

    require 'gherkin/parser'
    require 'cuke_modeler/adapters/gherkin_4_adapter'


    module CukeModeler

      module Parsing
        class << self

          def parse_text(source_text, filename = 'cuke_modeler_fake_file.feature')
            raise(ArgumentError, "Cannot parse #{source_text.class} objects. Strings only.") unless source_text.is_a?(String)

            begin
              parsed_result = Gherkin::Parser.new.parse(source_text)
            rescue => e
              raise(ArgumentError, "Error encountered while parsing '#{filename}'\n#{e.class} - #{e.message}")
            end

            adapted_result = CukeModeler::Gherkin4Adapter.new.adapt(parsed_result)

            adapted_result
          end
        end
      end
    end

  when Gem.loaded_specs['gherkin'].version.version[/^3/]

    require 'gherkin/parser'
    require 'cuke_modeler/adapters/gherkin_3_adapter'


    module CukeModeler

      module Parsing
        class << self

          def parse_text(source_text, filename = 'cuke_modeler_fake_file.feature')
            raise(ArgumentError, "Cannot parse #{source_text.class} objects. Strings only.") unless source_text.is_a?(String)

            begin
              parsed_result = Gherkin::Parser.new.parse(source_text)
            rescue => e
              raise(ArgumentError, "Error encountered while parsing '#{filename}'\n#{e.class} - #{e.message}")
            end

            adapted_result = CukeModeler::Gherkin3Adapter.new.adapt(parsed_result)

            adapted_result
          end
        end
      end
    end

  else

    require 'stringio'
    require 'gherkin/formatter/json_formatter'
    require 'gherkin'
    require 'json'
    require 'multi_json'
    require 'cuke_modeler/adapters/gherkin_2_adapter'


    module CukeModeler

      # A module providing source text parsing functionality.

      module Parsing

        class << self

          # Parses the Cucumber feature given in *source_text* and returns an array
          # containing the hash representation of its logical structure.
          def parse_text(source_text, filename = 'cuke_modeler_fake_file.feature')
            raise(ArgumentError, "Cannot parse #{source_text.class} objects. Strings only.") unless source_text.is_a?(String)

            io = StringIO.new
            formatter = Gherkin::Formatter::JSONFormatter.new(io)
            parser = Gherkin::Parser::Parser.new(formatter)

            begin
              parser.parse(source_text, filename, 0)
            rescue => e
              raise(ArgumentError, "Error encountered while parsing '#{filename}'\n#{e.class} - #{e.message}")
            end

            formatter.done


            parsed_result = MultiJson.load(io.string)
            adapted_result = CukeModeler::Gherkin2Adapter.new.adapt(parsed_result)

            adapted_result
          end

        end

      end
    end

end
