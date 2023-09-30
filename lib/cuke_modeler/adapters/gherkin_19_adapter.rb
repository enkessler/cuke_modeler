require_relative 'gherkin_18_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 19.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.
  class Gherkin19Adapter < Gherkin18Adapter

    # Adapts the AST sub-tree that is rooted at the given step node.
    def adapt_step(step_ast)
      adapted_step = super(step_ast)

      clear_child_elements(adapted_step, [[:dataTable],
                                          [:docString]])

      if step_ast[:docString]
        adapted_step['doc_string'] = adapt_doc_string(step_ast[:docString])
      elsif step_ast[:dataTable]
        adapted_step['table'] = adapt_step_table(step_ast[:dataTable])
      end

      adapted_step
    end

    # Adapts the AST sub-tree that is rooted at the given doc string node.
    def adapt_doc_string(doc_string_ast)
      adapted_doc_string = super(doc_string_ast)

      adapted_doc_string['content_type'] = doc_string_ast[:mediaType]

      adapted_doc_string
    end

    # Adapts the AST sub-tree that is rooted at the given example node.
    def adapt_example(example_ast)
      adapted_example = super(example_ast)

      clear_child_elements(adapted_example, [[:tableHeader],
                                             [:tableBody]])

      adapted_example['rows'] << adapt_table_row(example_ast[:tableHeader]) if example_ast[:tableHeader]

      example_ast[:tableBody].each do |row|
        adapted_example['rows'] << adapt_table_row(row)
      end

      adapted_example
    end


    private


    def test_has_examples?(ast_node)
      ast_node[:scenario][:examples].any?
    end

  end

  private_constant :Gherkin19Adapter
end
