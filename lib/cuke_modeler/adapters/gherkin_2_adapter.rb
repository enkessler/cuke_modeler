module CukeModeler

  # An adapter that can convert the output of version 2.x of the *gherkin* gem into input that is consumable by this gem.

  class Gherkin2Adapter

    # Adapts the given AST into the shape that this gem expects
    def adapt(parsed_ast)
      parsed_data = {}

      # The entire AST is just an array with one feature and we don't want to save any child data so...an empty array
      parsed_data['cuke_modeler_parsing_data'] = []

      # Comments are stored on child elements in gherkin 2.x
      comments = []

      # An AST is just one feature
      adapt_feature!(parsed_ast.first, comments) if parsed_ast.first
      parsed_data['feature'] = parsed_ast.first

      # Adapt and store comments once they have all been gathered
      comments.each do |comment|
        adapt_comment!(comment)
      end
      parsed_data['comments'] = comments


      [parsed_data]
    end

    # Adapts the AST sub-tree that is rooted at the given feature node.
    def adapt_feature!(parsed_feature, gathered_comments)
      # Saving off the original data
      parsed_feature['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_feature))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_feature['cuke_modeler_parsing_data']['tags'] = nil
      parsed_feature['cuke_modeler_parsing_data']['elements'] = nil

      if parsed_feature['comments']
        parsed_feature['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_feature['comments'])
      end

      adapt_child_elements!(parsed_feature, gathered_comments)

      if parsed_feature['tags']
        parsed_feature['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end
    end

    # Adapts the AST sub-tree that is rooted at the given background node.
    def adapt_background!(parsed_background, gathered_comments)
      # Saving off the original data
      parsed_background['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_background))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_background['cuke_modeler_parsing_data']['steps'] = nil

      if parsed_background['comments']
        parsed_background['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_background['comments'])
      end

      if parsed_background['steps']
        parsed_background['steps'].each do |step|
          adapt_step!(step, gathered_comments)
        end
      end
    end

    # Adapts the AST sub-tree that is rooted at the given scenario node.
    def adapt_scenario!(parsed_scenario, gathered_comments)
      # Saving off the original data
      parsed_scenario['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_scenario))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_scenario['cuke_modeler_parsing_data']['tags'] = nil
      parsed_scenario['cuke_modeler_parsing_data']['steps'] = nil

      if parsed_scenario['comments']
        parsed_scenario['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_scenario['comments'])
      end

      if parsed_scenario['tags']
        parsed_scenario['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end

      if parsed_scenario['steps']
        parsed_scenario['steps'].each do |step|
          adapt_step!(step, gathered_comments)
        end
      end
    end

    # Adapts the AST sub-tree that is rooted at the given outline node.
    def adapt_outline!(parsed_outline, gathered_comments)
      # Saving off the original data
      parsed_outline['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_outline))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_outline['cuke_modeler_parsing_data']['tags'] = nil
      parsed_outline['cuke_modeler_parsing_data']['steps'] = nil
      parsed_outline['cuke_modeler_parsing_data']['examples'] = nil

      if parsed_outline['comments']
        parsed_outline['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_outline['comments'])
      end

      if parsed_outline['tags']
        parsed_outline['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end

      if parsed_outline['steps']
        parsed_outline['steps'].each do |step|
          adapt_step!(step, gathered_comments)
        end
      end

      if parsed_outline['examples']
        parsed_outline['examples'].each do |example|
          adapt_example!(example, gathered_comments)
        end
      end
    end

    # Adapts the AST sub-tree that is rooted at the given example node.
    def adapt_example!(parsed_example, gathered_comments)
      # Saving off the original data
      parsed_example['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_example))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_example['cuke_modeler_parsing_data']['tags'] = nil
      parsed_example['cuke_modeler_parsing_data']['rows'] = nil

      if parsed_example['comments']
        parsed_example['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_example['comments'])
      end

      parsed_example['rows'].each do |row|
        adapt_table_row!(row, gathered_comments)
      end

      if parsed_example['tags']
        parsed_example['tags'].each do |tag|
          adapt_tag!(tag)
        end
      end
    end

    # Adapts the AST sub-tree that is rooted at the given tag node.
    def adapt_tag!(parsed_tag)
      # Saving off the original data
      parsed_tag['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_tag))
    end

    # Adapts the AST sub-tree that is rooted at the given comment node.
    def adapt_comment!(parsed_comment)
      # Saving off the original data
      parsed_comment['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_comment))

      parsed_comment['text'] = parsed_comment.delete('value')
      parsed_comment['line'] = parsed_comment.delete('line')
    end

    # Adapts the AST sub-tree that is rooted at the given step node.
    def adapt_step!(parsed_step, gathered_comments)
      # Saving off the original data
      parsed_step['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_step))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_step['cuke_modeler_parsing_data']['rows'] = nil if parsed_step['cuke_modeler_parsing_data']['rows']
      parsed_step['cuke_modeler_parsing_data']['doc_string'] = nil if parsed_step['cuke_modeler_parsing_data']['doc_string']

      if parsed_step['comments']
        parsed_step['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_step['comments'])
      end

      adapt_doc_string!(parsed_step['doc_string']) if parsed_step['doc_string']

      if parsed_step['rows']
        parsed_step['table'] = {'rows' => parsed_step['rows']}
        adapt_step_table!(parsed_step['table'], gathered_comments)
      end
    end

    # Adapts the AST sub-tree that is rooted at the given doc string node.
    def adapt_doc_string!(parsed_doc_string)
      # Saving off the original data
      parsed_doc_string['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_doc_string))
    end

    # Adapts the AST sub-tree that is rooted at the given table node.
    def adapt_step_table!(parsed_step_table, gathered_comments)
      # Saving off the original data
      parsed_step_table['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_step_table['rows']))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_step_table['cuke_modeler_parsing_data'].clear


      parsed_step_table['line'] = parsed_step_table['rows'].first['line']

      parsed_step_table['rows'].each do |row|
        adapt_table_row!(row, gathered_comments)
      end
    end

    # Adapts the AST sub-tree that is rooted at the given row node.
    def adapt_table_row!(parsed_table_row, gathered_comments)
      # Saving off the original data
      parsed_table_row['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_table_row))

      # Removing parsed data for child elements in order to avoid duplicating data which the child elements will themselves include
      parsed_table_row['cuke_modeler_parsing_data']['cells'] = nil

      if parsed_table_row['comments']
        parsed_table_row['cuke_modeler_parsing_data']['comments'] = nil
        gathered_comments.concat(parsed_table_row['comments'])
      end

      parsed_table_row['cells'].collect! do |cell|
        create_cell_for(cell, parsed_table_row['line'])
      end
    end

    # Adapts the AST sub-tree that is rooted at the given cell node.
    def create_cell_for(parsed_cell, line_number)
      cell = {}

      # Saving off the original data
      cell['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_cell))

      cell['value'] = parsed_cell
      cell['line'] = line_number


      cell
    end


    private


    def adapt_child_elements!(parsed_feature, gathered_comments)
      if parsed_feature['elements']
        parsed_feature['elements'].each do |element|
          case element['type']
            when 'background'
              adapt_background!(element, gathered_comments)
            when 'scenario'
              adapt_scenario!(element, gathered_comments)
            when 'scenario_outline'
              adapt_outline!(element, gathered_comments)
            else
              raise(ArgumentError, "Unknown element type: #{element['type']}")
          end
        end
      end
    end

  end
end
