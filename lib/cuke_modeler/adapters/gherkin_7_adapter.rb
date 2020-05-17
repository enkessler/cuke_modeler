module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 7.x of the *gherkin* gem into input that is consumable by this gem.

  class Gherkin7Adapter

    # Adapts the given AST into the shape that this gem expects
    def adapt(parsed_ast)
      # Saving off the original data
      parsed_ast['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_ast))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_ast['cuke_modeler_parsing_data'][:feature] = nil
      parsed_ast['cuke_modeler_parsing_data'][:comments] = nil

      parsed_ast['comments'] = []
      parsed_ast[:comments].each do |comment|
        adapt_comment!(comment)
      end
      parsed_ast['comments'].concat(parsed_ast.delete(:comments))

      adapt_feature!(parsed_ast[:feature]) if parsed_ast[:feature]
      parsed_ast['feature'] = parsed_ast.delete(:feature)

      [parsed_ast]
    end

    # Adapts the AST sub-tree that is rooted at the given feature node.
    def adapt_feature!(parsed_feature)
      # Saving off the original data
      parsed_feature['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_feature))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_feature['cuke_modeler_parsing_data'][:tags] = nil
      parsed_feature['cuke_modeler_parsing_data'][:children] = nil

      parsed_feature['keyword'] = parsed_feature.delete(:keyword)
      parsed_feature['name'] = parsed_feature.delete(:name)
      parsed_feature['description'] = parsed_feature.delete(:description)
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

    # Adapts the AST sub-tree that is rooted at the given background node.
    def adapt_background!(parsed_background)
      # Saving off the original data
      parsed_background['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_background))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_background['cuke_modeler_parsing_data'][:background][:steps] = nil

      parsed_background['type'] = 'Background'
      parsed_background['keyword'] = parsed_background[:background].delete(:keyword)
      parsed_background['name'] = parsed_background[:background].delete(:name)
      parsed_background['description'] = parsed_background[:background].delete(:description)
      parsed_background['line'] = parsed_background[:background].delete(:location)[:line]

      parsed_background['steps'] = []
      parsed_background[:background][:steps].each do |step|
        adapt_step!(step)
      end
      parsed_background['steps'].concat(parsed_background[:background].delete(:steps))
    end

    # Adapts the AST sub-tree that is rooted at the given scenario node.
    def adapt_scenario!(parsed_test)
      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_test['cuke_modeler_parsing_data'][:scenario][:tags] = nil
      parsed_test['cuke_modeler_parsing_data'][:scenario][:steps] = nil

      parsed_test['type'] = 'Scenario'
      parsed_test['keyword'] = parsed_test[:scenario].delete(:keyword)
      parsed_test['name'] = parsed_test[:scenario].delete(:name)
      parsed_test['description'] = parsed_test[:scenario].delete(:description)
      parsed_test['line'] = parsed_test[:scenario].delete(:location)[:line]

      parsed_test['tags'] = []
      parsed_test[:scenario][:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_test['tags'].concat(parsed_test[:scenario].delete(:tags))

      parsed_test['steps'] = []
      parsed_test[:scenario][:steps].each do |step|
        adapt_step!(step)
      end
      parsed_test['steps'].concat(parsed_test[:scenario].delete(:steps))
    end

    # Adapts the AST sub-tree that is rooted at the given outline node.
    def adapt_outline!(parsed_test)
      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_test['cuke_modeler_parsing_data'][:scenario][:tags] = nil
      parsed_test['cuke_modeler_parsing_data'][:scenario][:steps] = nil
      parsed_test['cuke_modeler_parsing_data'][:scenario][:examples] = nil

      parsed_test['type'] = 'ScenarioOutline'
      parsed_test['keyword'] = parsed_test[:scenario].delete(:keyword)
      parsed_test['name'] = parsed_test[:scenario].delete(:name)
      parsed_test['description'] = parsed_test[:scenario].delete(:description)
      parsed_test['line'] = parsed_test[:scenario].delete(:location)[:line]

      parsed_test['tags'] = []
      parsed_test[:scenario][:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_test['tags'].concat(parsed_test[:scenario].delete(:tags))

      parsed_test['steps'] = []
      parsed_test[:scenario][:steps].each do |step|
        adapt_step!(step)
      end
      parsed_test['steps'].concat(parsed_test[:scenario].delete(:steps))

      parsed_test['examples'] = []
      parsed_test[:scenario][:examples].each do |step|
        adapt_example!(step)
      end
      parsed_test['examples'].concat(parsed_test[:scenario].delete(:examples))
    end

    # Adapts the AST sub-tree that is rooted at the given example node.
    def adapt_example!(parsed_example)
      # Saving off the original data
      parsed_example['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_example))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_example['cuke_modeler_parsing_data'][:tags] = nil
      parsed_example['cuke_modeler_parsing_data'][:table_header] = nil
      parsed_example['cuke_modeler_parsing_data'][:table_body] = nil

      parsed_example['keyword'] = parsed_example.delete(:keyword)
      parsed_example['name'] = parsed_example.delete(:name)
      parsed_example['line'] = parsed_example.delete(:location)[:line]
      parsed_example['description'] = parsed_example.delete(:description)

      parsed_example['rows'] = []

      if parsed_example[:table_header]
        adapt_table_row!(parsed_example[:table_header])
        parsed_example['rows'] << parsed_example.delete(:table_header)
      end

      if parsed_example[:table_body]
        parsed_example[:table_body].each do |row|
          adapt_table_row!(row)
        end
        parsed_example['rows'].concat(parsed_example.delete(:table_body))
      end

      parsed_example['tags'] = []
      parsed_example[:tags].each do |tag|
        adapt_tag!(tag)
      end
      parsed_example['tags'].concat(parsed_example.delete(:tags))
    end

    # Adapts the AST sub-tree that is rooted at the given tag node.
    def adapt_tag!(parsed_tag)
      # Saving off the original data
      parsed_tag['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_tag))

      parsed_tag['name'] = parsed_tag.delete(:name)
      parsed_tag['line'] = parsed_tag.delete(:location)[:line]
    end

    # Adapts the AST sub-tree that is rooted at the given comment node.
    def adapt_comment!(parsed_comment)
      # Saving off the original data
      parsed_comment['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_comment))

      parsed_comment['text'] = parsed_comment.delete(:text)
      parsed_comment['line'] = parsed_comment.delete(:location)[:line]
    end

    # Adapts the AST sub-tree that is rooted at the given step node.
    def adapt_step!(parsed_step)
      # Saving off the original data
      parsed_step['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_step))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_step['cuke_modeler_parsing_data'][:data_table] = nil
      parsed_step['cuke_modeler_parsing_data'][:doc_string] = nil

      parsed_step['keyword'] = parsed_step.delete(:keyword)
      parsed_step['name'] = parsed_step.delete(:text)
      parsed_step['line'] = parsed_step.delete(:location)[:line]


      case
        when parsed_step[:doc_string]
          adapt_doc_string!(parsed_step[:doc_string])
          parsed_step['doc_string'] = parsed_step.delete(:doc_string)
        when parsed_step[:data_table]
          adapt_step_table!(parsed_step[:data_table])
          parsed_step['table'] = parsed_step.delete(:data_table)
        else
          # Step has no extra argument
      end
    end

    # Adapts the AST sub-tree that is rooted at the given doc string node.
    def adapt_doc_string!(parsed_doc_string)
      # Saving off the original data
      parsed_doc_string['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_doc_string))

      parsed_doc_string['value'] = parsed_doc_string.delete(:content)
      parsed_doc_string['content_type'] = parsed_doc_string.delete(:content_type).strip # TODO: fix bug in Gherkin so that this whitespace is already trimmed off
      parsed_doc_string['line'] = parsed_doc_string.delete(:location)[:line]
    end

    # Adapts the AST sub-tree that is rooted at the given table node.
    def adapt_step_table!(parsed_step_table)
      # Saving off the original data
      parsed_step_table['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_step_table))

      # Removing parsed data for child elements in order to avoid duplicating data
      parsed_step_table['cuke_modeler_parsing_data'][:rows] = nil

      parsed_step_table['rows'] = []
      parsed_step_table[:rows].each do |row|
        adapt_table_row!(row)
      end
      parsed_step_table['rows'].concat(parsed_step_table.delete(:rows))
      parsed_step_table['line'] = parsed_step_table.delete(:location)[:line]
    end

    # Adapts the AST sub-tree that is rooted at the given row node.
    def adapt_table_row!(parsed_table_row)
      # Saving off the original data
      parsed_table_row['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_table_row))

      # Removing parsed data for child elements in order to avoid duplicating data which the child elements will themselves include
      parsed_table_row['cuke_modeler_parsing_data'][:cells] = nil


      parsed_table_row['line'] = parsed_table_row.delete(:location)[:line]

      parsed_table_row['cells'] = []
      parsed_table_row[:cells].each do |row|
        adapt_table_cell!(row)
      end
      parsed_table_row['cells'].concat(parsed_table_row.delete(:cells))
    end

    # Adapts the AST sub-tree that is rooted at the given cell node.
    def adapt_table_cell!(parsed_cell)
      # Saving off the original data
      parsed_cell['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_cell))

      parsed_cell['value'] = parsed_cell.delete(:value)
      parsed_cell['line'] = parsed_cell.delete(:location)[:line]
    end


    private


    def adapt_child_elements!(parsed_children)
      return if parsed_children.empty?

      background_child = parsed_children.find { |child| child[:background] }

      if background_child
        adapt_background!(background_child)

        remaining_children = parsed_children.reject { |child| child[:background] }
      end

      adapt_tests!(remaining_children || parsed_children)
    end

    def adapt_tests!(parsed_tests)
      return unless parsed_tests

      parsed_tests.each do |test|
        adapt_test!(test)
      end
    end

    def adapt_test!(parsed_test)
      # Saving off the original data
      parsed_test['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(parsed_test))


      case
        when parsed_test[:scenario] && parsed_test[:scenario][:examples].any?
          adapt_outline!(parsed_test)
        when parsed_test[:scenario]
          adapt_scenario!(parsed_test)
        else
          raise(ArgumentError, "Unknown test type with keys: #{parsed_test.keys}")
      end
    end

  end
end