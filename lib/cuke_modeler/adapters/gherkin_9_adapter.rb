# Some things just aren't going to get better due to the inherent complexity of the AST
# rubocop:disable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength

module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 9.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin9Adapter

    # Adapts the given AST into the shape that this gem expects
    def adapt(ast)
      adapted_ast = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_ast, ast)
      clear_child_elements(adapted_ast, [[:feature],
                                         [:comments]])

      adapted_ast['comments'] = adapt_comments(ast)
      adapted_ast['feature'] = adapt_feature(ast[:feature])

      adapted_ast
    end

    # Adapts the AST sub-tree that is rooted at the given feature node.
    def adapt_feature(feature_ast)
      return nil unless feature_ast

      adapted_feature = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_feature, feature_ast)
      clear_child_elements(adapted_feature, [[:tags],
                                             [:children]])

      adapted_feature['keyword'] = feature_ast[:keyword]
      adapted_feature['name'] = feature_ast[:name]
      adapted_feature['description'] = feature_ast[:description] || ''
      adapted_feature['line'] = feature_ast[:location][:line]

      adapted_feature['elements'] = adapt_child_elements(feature_ast)
      adapted_feature['tags'] = adapt_tags(feature_ast)

      adapted_feature
    end

    # Adapts the AST sub-tree that is rooted at the given background node.
    def adapt_background(background_ast)
      adapted_background = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_background, background_ast)
      clear_child_elements(adapted_background, [[:background, :steps]])

      adapted_background['type'] = 'Background'
      adapted_background['keyword'] = background_ast[:background][:keyword]
      adapted_background['name'] = background_ast[:background][:name]
      adapted_background['description'] = background_ast[:background][:description] || ''
      adapted_background['line'] = background_ast[:background][:location][:line]

      adapted_background['steps'] = adapt_steps(background_ast[:background])

      adapted_background
    end

    # Adapts the AST sub-tree that is rooted at the given rule node.
    def adapt_rule(rule_ast)
      adapted_rule = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_rule, rule_ast)
      clear_child_elements(adapted_rule, [[:rule, :children]])

      adapted_rule['type'] = 'Rule'
      adapted_rule['keyword'] = rule_ast[:rule][:keyword]
      adapted_rule['name'] = rule_ast[:rule][:name]
      adapted_rule['description'] = rule_ast[:rule][:description] || ''
      adapted_rule['line'] = rule_ast[:rule][:location][:line]

      adapted_rule['elements'] = adapt_child_elements(rule_ast[:rule])

      adapted_rule
    end

    # Adapts the AST sub-tree that is rooted at the given scenario node.
    def adapt_scenario(test_ast)
      adapted_scenario = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_scenario, test_ast)
      clear_child_elements(adapted_scenario, [[:scenario, :tags],
                                              [:scenario, :steps]])

      adapted_scenario['type'] = 'Scenario'
      adapted_scenario['keyword'] = test_ast[:scenario][:keyword]
      adapted_scenario['name'] = test_ast[:scenario][:name]
      adapted_scenario['description'] = test_ast[:scenario][:description] || ''
      adapted_scenario['line'] = test_ast[:scenario][:location][:line]

      adapted_scenario['tags'] = adapt_tags(test_ast[:scenario])
      adapted_scenario['steps'] = adapt_steps(test_ast[:scenario])

      adapted_scenario
    end

    # Adapts the AST sub-tree that is rooted at the given outline node.
    def adapt_outline(test_ast)
      adapted_outline = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_outline, test_ast)
      clear_child_elements(adapted_outline, [[:scenario, :tags],
                                             [:scenario, :steps],
                                             [:scenario, :examples]])

      adapted_outline['type'] = 'ScenarioOutline'
      adapted_outline['keyword'] = test_ast[:scenario][:keyword]
      adapted_outline['name'] = test_ast[:scenario][:name]
      adapted_outline['description'] = test_ast[:scenario][:description] || ''
      adapted_outline['line'] = test_ast[:scenario][:location][:line]

      adapted_outline['tags'] = adapt_tags(test_ast[:scenario])
      adapted_outline['steps'] = adapt_steps(test_ast[:scenario])
      adapted_outline['examples'] = adapt_examples(test_ast[:scenario])

      adapted_outline
    end

    # Adapts the AST sub-tree that is rooted at the given example node.
    def adapt_example(example_ast)
      adapted_example = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_example, example_ast)
      clear_child_elements(adapted_example, [[:tags],
                                             [:table_header],
                                             [:table_body]])

      adapted_example['keyword'] = example_ast[:keyword]
      adapted_example['name'] = example_ast[:name]
      adapted_example['line'] = example_ast[:location][:line]
      adapted_example['description'] = example_ast[:description] || ''

      adapted_example['rows'] = []
      adapted_example['rows'] << adapt_table_row(example_ast[:table_header]) if example_ast[:table_header]

      example_ast[:table_body]&.each do |row|
        adapted_example['rows'] << adapt_table_row(row)
      end

      adapted_example['tags'] = adapt_tags(example_ast)

      adapted_example
    end

    # Adapts the AST sub-tree that is rooted at the given tag node.
    def adapt_tag(tag_ast)
      adapted_tag = {}

      # Saving off the original data
      save_original_data(adapted_tag, tag_ast)

      adapted_tag['name'] = tag_ast[:name]
      adapted_tag['line'] = tag_ast[:location][:line]

      adapted_tag
    end

    # Adapts the AST sub-tree that is rooted at the given comment node.
    def adapt_comment(comment_ast)
      adapted_comment = {}

      # Saving off the original data
      save_original_data(adapted_comment, comment_ast)

      adapted_comment['text'] = comment_ast[:text]
      adapted_comment['line'] = comment_ast[:location][:line]

      adapted_comment
    end

    # Adapts the AST sub-tree that is rooted at the given step node.
    def adapt_step(step_ast)
      adapted_step = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_step, step_ast)
      clear_child_elements(adapted_step, [[:data_table],
                                          [:doc_string]])

      adapted_step['keyword'] = step_ast[:keyword]
      adapted_step['name'] = step_ast[:text]
      adapted_step['line'] = step_ast[:location][:line]

      if step_ast[:doc_string]
        adapted_step['doc_string'] = adapt_doc_string(step_ast[:doc_string])
      elsif step_ast[:data_table]
        adapted_step['table'] = adapt_step_table(step_ast[:data_table])
      end

      adapted_step
    end

    # Adapts the AST sub-tree that is rooted at the given doc string node.
    def adapt_doc_string(doc_string_ast)
      adapted_doc_string = {}

      # Saving off the original data
      save_original_data(adapted_doc_string, doc_string_ast)

      adapted_doc_string['value'] = doc_string_ast[:content]
      adapted_doc_string['content_type'] = doc_string_ast[:media_type]
      adapted_doc_string['line'] = doc_string_ast[:location][:line]

      adapted_doc_string
    end

    # Adapts the AST sub-tree that is rooted at the given table node.
    def adapt_step_table(step_table_ast)
      adapted_step_table = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_step_table, step_table_ast)
      clear_child_elements(adapted_step_table, [[:rows]])

      adapted_step_table['rows'] = []
      step_table_ast[:rows].each do |row|
        adapted_step_table['rows'] << adapt_table_row(row)
      end
      adapted_step_table['line'] = step_table_ast[:location][:line]

      adapted_step_table
    end

    # Adapts the AST sub-tree that is rooted at the given row node.
    def adapt_table_row(table_row_ast)
      adapted_table_row = {}

      # Saving off the original data and removing parsed data for child elements in order to avoid duplicating data
      save_original_data(adapted_table_row, table_row_ast)
      clear_child_elements(adapted_table_row, [[:cells]])

      adapted_table_row['line'] = table_row_ast[:location][:line]

      adapted_table_row['cells'] = []
      table_row_ast[:cells].each do |row|
        adapted_table_row['cells'] << adapt_table_cell(row)
      end

      adapted_table_row
    end

    # Adapts the AST sub-tree that is rooted at the given cell node.
    def adapt_table_cell(cell_ast)
      adapted_cell = {}

      # Saving off the original data
      save_original_data(adapted_cell, cell_ast)

      adapted_cell['value'] = cell_ast[:value]
      adapted_cell['line'] = cell_ast[:location][:line]

      adapted_cell
    end


    private


    def adapt_comments(file_ast)
      return [] unless file_ast[:comments]

      file_ast[:comments].map { |comment| adapt_comment(comment) }
    end

    def adapt_tags(element_ast)
      return [] unless element_ast[:tags]

      element_ast[:tags].map { |tag| adapt_tag(tag) }
    end

    def adapt_steps(element_ast)
      return [] unless element_ast[:steps]

      element_ast[:steps].map { |step| adapt_step(step) }
    end

    def adapt_examples(element_ast)
      return [] unless element_ast[:examples]

      element_ast[:examples].map { |example| adapt_example(example) }
    end

    def adapt_child_elements(element_ast)
      return [] unless element_ast[:children]

      adapted_children = []

      element_ast[:children].each do |child_element|
        adapted_children << if child_element[:background]
                              adapt_background(child_element)
                            elsif child_element[:rule]
                              adapt_rule(child_element)
                            else
                              adapt_test(child_element)
                            end
      end

      adapted_children
    end

    def adapt_test(test_ast)
      if (test_node?(test_ast) && test_has_examples?(test_ast)) ||
         (test_node?(test_ast) && test_uses_outline_keyword?(test_ast))

        adapt_outline(test_ast)
      elsif test_node?(test_ast)
        adapt_scenario(test_ast)
      else
        raise(ArgumentError, "Unknown test type with keys: #{test_ast.keys}")
      end
    end

    def save_original_data(adapted_ast, raw_ast)
      adapted_ast['cuke_modeler_parsing_data'] = Marshal::load(Marshal.dump(raw_ast))
    end

    def clear_child_elements(ast, child_paths)
      child_paths.each do |traversal_path|
        if ast['cuke_modeler_parsing_data'].dig(*traversal_path)
          bury(ast['cuke_modeler_parsing_data'], traversal_path, nil)
        end
      end
    end

    def bury(hash, traversal_path, value)
      keys = *traversal_path

      current = hash
      (keys.count - 1).times do |index|
        current = hash[keys[index]]
      end

      current[keys.last] = value
    end

    def test_node?(ast_node)
      ast_node[:scenario]
    end

    def test_has_examples?(ast_node)
      ast_node[:scenario][:examples]
    end

    def test_uses_outline_keyword?(test_ast)
      Parsing.dialects[Parsing.dialect]['scenarioOutline'].include?(test_ast[:scenario][:keyword])
    end

  end
end

# rubocop:enable Metrics/ClassLength, Metrics/AbcSize, Metrics/MethodLength
