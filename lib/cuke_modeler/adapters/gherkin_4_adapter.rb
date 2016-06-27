module CukeModeler
  class Gherkin4Adapter


    def adapt(parsed_ast)
      adapt_feature!(parsed_ast[:feature]) if parsed_ast[:feature]

      [parsed_ast[:feature]].compact
    end

    def adapt_feature!(parsed_feature)
      # Saving off the original data
      parsed_feature['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_feature))

      parsed_feature['name'] = parsed_feature.delete(:name)
      parsed_feature['description'] = parsed_feature.delete(:description) || ''
      parsed_feature['line'] = parsed_feature.delete(:location)[:line]

      parsed_feature['elements'] = []
      adapt_child_elements!(parsed_feature[:children])
      parsed_feature['elements'].concat(parsed_feature.delete(:children))

      parsed_feature['tags'] = []
      parsed_feature[:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_feature['tags'].concat(parsed_feature.delete(:tags))
    end

    def adapt_child_elements!(parsed_children)
      return if parsed_children.empty?

      if parsed_children.first[:type] == :Background
        adapt_background!(parsed_children.first)

        remaining_children = parsed_children[1..-1]
      end

      adapt_tests!(remaining_children || parsed_children)
    end

    def adapt_background!(parsed_background)
      # Saving off the original data
      parsed_background['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_background))

      parsed_background['keyword'] = parsed_background.delete(:type).to_s
      parsed_background['name'] = parsed_background.delete(:name)
      parsed_background['description'] = parsed_background.delete(:description) || ''
      parsed_background['line'] = parsed_background.delete(:location)[:line]

      parsed_background['steps'] = []
      parsed_background[:steps].each do |step|
        adapt_step!(step)
      end
      parsed_background['steps'].concat(parsed_background.delete(:steps))
    end

    def adapt_tests!(parsed_tests)
      return unless parsed_tests

      parsed_tests.each do |test|
        adapt_test!(test)
      end
    end

    def adapt_test!(parsed_test)
      # Saving off the original data
      parsed_test['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_test))

      parsed_test['keyword'] = parsed_test.delete(:type).to_s

      case parsed_test['keyword']
        when 'Scenario'
          adapt_scenario!(parsed_test)
        when 'ScenarioOutline'
          parsed_test['keyword'] = 'Scenario Outline'
          adapt_outline!(parsed_test)
        else
          raise(ArgumentError, "Unknown test type: #{parsed_test['keyword']}")
      end
    end

    def adapt_scenario!(parsed_test)
      parsed_test['name'] = parsed_test.delete(:name)
      parsed_test['description'] = parsed_test.delete(:description) || ''
      parsed_test['line'] = parsed_test.delete(:location)[:line]

      parsed_test['tags'] = []
      parsed_test[:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_test['tags'].concat(parsed_test.delete(:tags))

      parsed_test['steps'] = []
      parsed_test[:steps].each do |step|
        adapt_step!(step)
      end
      parsed_test['steps'].concat(parsed_test.delete(:steps))
    end

    def adapt_outline!(parsed_test)
      parsed_test['name'] = parsed_test.delete(:name)
      parsed_test['description'] = parsed_test.delete(:description) || ''
      parsed_test['line'] = parsed_test.delete(:location)[:line]

      parsed_test['tags'] = []
      parsed_test[:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_test['tags'].concat(parsed_test.delete(:tags))

      parsed_test['steps'] = []
      parsed_test[:steps].each do |step|
        adapt_step!(step)
      end
      parsed_test['steps'].concat(parsed_test.delete(:steps))

      parsed_test['examples'] = []
      parsed_test[:examples].each do |step|
        adapt_example!(step)
      end
      parsed_test['examples'].concat(parsed_test.delete(:examples))
    end

    def adapt_example!(parsed_example)
      # Saving off the original data
      parsed_example['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_example))

      parsed_example['name'] = parsed_example.delete(:name)
      parsed_example['line'] = parsed_example.delete(:location)[:line]
      parsed_example['description'] = parsed_example.delete(:description) || ''

      parsed_example['rows'] = []

      if parsed_example[:tableHeader]
        parsed_example['rows'] << adapt_table_row!(parsed_example.delete(:tableHeader))
      end

      if parsed_example[:tableBody]

        parsed_example[:tableBody].each do |row|
          adapt_table_row!(row)
        end
        parsed_example['rows'].concat(parsed_example.delete(:tableBody))
      end


      parsed_example['tags'] = []
      parsed_example[:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_example['tags'].concat(parsed_example.delete(:tags))
    end

    def adapt_tag!(parsed_tag)
      # Saving off the original data
      parsed_tag['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_tag))

      parsed_tag['name'] = parsed_tag.delete(:name)
      parsed_tag['line'] = parsed_tag.delete(:location)[:line]
    end

    def adapt_step!(parsed_step)
      # Saving off the original data
      parsed_step['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_step))

      parsed_step['keyword'] = parsed_step.delete(:keyword)
      parsed_step['name'] = parsed_step.delete(:text)
      parsed_step['line'] = parsed_step.delete(:location)[:line]


      step_argument = parsed_step[:argument]

      if step_argument
        case step_argument[:type]
          when :DocString
            adapt_doc_string!(step_argument)
            parsed_step['doc_string'] = parsed_step.delete(:argument)
          when :DataTable
            adapt_step_table!(step_argument)
            parsed_step['rows'] = parsed_step.delete(:argument)
          else
            raise(ArgumentError, "Unknown step argument type: #{step_argument[:type]}")
        end
      end
    end

    def adapt_doc_string!(parsed_doc_string)
      # Saving off the original data
      parsed_doc_string['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_doc_string))

      parsed_doc_string['value'] = parsed_doc_string.delete(:content)
      parsed_doc_string['content_type'] = parsed_doc_string.delete(:contentType)
      parsed_doc_string['line'] = parsed_doc_string.delete(:location)[:line]
    end

    def adapt_step_table!(parsed_step_table)
      # Saving off the original data
      parsed_step_table['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_step_table))

      parsed_step_table['rows'] = []
      parsed_step_table[:rows].each do |row|
        adapt_table_row!(row)
      end
      parsed_step_table['rows'].concat(parsed_step_table.delete(:rows))
      parsed_step_table['line'] = parsed_step_table.delete(:location)[:line]
    end

    def adapt_table_row!(parsed_table_row)
      # Saving off the original data
      parsed_table_row['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_table_row))

      parsed_table_row['line'] = parsed_table_row.delete(:location)[:line]

      parsed_table_row['cells'] = parsed_table_row.delete(:cells).collect { |cell| cell[:value] }


      parsed_table_row
    end

  end
end
