module CukeModeler
  class Gherkin2Adapter


    def adapt(parsed_ast)
      # An AST is just one feature
      adapt_feature!(parsed_ast.first) if parsed_ast.first

      parsed_ast
    end

    def adapt_feature!(parsed_feature)
      # Saving off the original data
      parsed_feature['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_feature))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_feature['cuke_modeler_raw_adapter_output']['tags'] = nil
      parsed_feature['cuke_modeler_raw_adapter_output']['elements'] = nil


      adapt_child_elements!(parsed_feature)

      if parsed_feature['tags']
        parsed_feature['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end
    end

    def adapt_child_elements!(parsed_feature)
      if parsed_feature['elements']
        parsed_feature['elements'].each do |element|
          case element['keyword']
            when 'Background'
              adapt_background!(element)
            when 'Scenario'
              adapt_scenario!(element)
            when 'Scenario Outline'
              adapt_outline!(element)
            else
              raise("Unknown element keyword: #{element['keyword']}")
          end
        end
      end
    end

    def adapt_background!(parsed_background)
      # Saving off the original data
      parsed_background['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_background))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_background['cuke_modeler_raw_adapter_output']['steps'] = nil

      if parsed_background['steps']
        parsed_background['steps'].each do |step|
          adapt_step!(step)
        end
      end
    end

    def adapt_scenario!(parsed_scenario)
      # Saving off the original data
      parsed_scenario['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_scenario))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_scenario['cuke_modeler_raw_adapter_output']['tags'] = nil
      parsed_scenario['cuke_modeler_raw_adapter_output']['steps'] = nil


      if parsed_scenario['tags']
        parsed_scenario['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end

      if parsed_scenario['steps']
        parsed_scenario['steps'].each do |step|
          adapt_step!(step)
        end
      end
    end

    def adapt_outline!(parsed_outline)
      # Saving off the original data
      parsed_outline['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_outline))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_outline['cuke_modeler_raw_adapter_output']['tags'] = nil
      parsed_outline['cuke_modeler_raw_adapter_output']['steps'] = nil
      parsed_outline['cuke_modeler_raw_adapter_output']['examples'] = nil


      if parsed_outline['tags']
        parsed_outline['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end

      if parsed_outline['steps']
        parsed_outline['steps'].each do |step|
          adapt_step!(step)
        end
      end

      if parsed_outline['examples']
        parsed_outline['examples'].each do |example|
          adapt_example!(example)
        end
      end
    end

    def adapt_example!(parsed_example)
      # Saving off the original data
      parsed_example['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_example))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_example['cuke_modeler_raw_adapter_output']['tags'] = nil
      parsed_example['cuke_modeler_raw_adapter_output']['rows'] = nil


      parsed_example['rows'].each do |row|
        adapt_table_row!(row)
      end

      if parsed_example['tags']
        parsed_example['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end
    end

    def adapt_tag!(parsed_tag)
      # Saving off the original data
      parsed_tag['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_tag))
    end

    def adapt_step!(parsed_step)
      # Saving off the original data
      parsed_step['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_step))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_step['cuke_modeler_raw_adapter_output']['rows'] = nil if parsed_step['cuke_modeler_raw_adapter_output']['rows']
      parsed_step['cuke_modeler_raw_adapter_output']['doc_string'] = nil if parsed_step['cuke_modeler_raw_adapter_output']['doc_string']


      adapt_doc_string!(parsed_step['doc_string']) if parsed_step['doc_string']

      if parsed_step['rows']
        parsed_step['table'] = {'rows' => parsed_step['rows']}
        adapt_step_table!(parsed_step['table'])
      end
    end

    def adapt_doc_string!(parsed_doc_string)
      # Saving off the original data
      parsed_doc_string['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_doc_string))
    end

    def adapt_step_table!(parsed_step_table)
      # Saving off the original data
      parsed_step_table['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_step_table['rows']))

      # Removing raw data for child models in order to avoid duplicating data
      parsed_step_table['cuke_modeler_raw_adapter_output'].clear


      parsed_step_table['line'] = parsed_step_table['rows'].first['line']

      parsed_step_table['rows'].each do |row|
        adapt_table_row!(row)
      end
    end

    def adapt_table_row!(parsed_table_row)
      # Saving off the original data
      parsed_table_row['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_table_row))

      # Removing raw data for child models in order to avoid duplicating data which the child models will themselves include
      parsed_table_row['cuke_modeler_raw_adapter_output']['cells'] = nil

      parsed_table_row['cells'].collect! do |cell|
        create_cell_for(cell, parsed_table_row['line'])
      end
    end

    def create_cell_for(parsed_cell, line_number)
      cell = {}

      # Saving off the original data
      cell['cuke_modeler_raw_adapter_output'] = Marshal::load(Marshal.dump(parsed_cell))

      cell['value'] = parsed_cell
      cell['line'] = line_number


      cell
    end

  end
end
