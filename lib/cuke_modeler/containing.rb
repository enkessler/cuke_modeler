# It's the module that has functionality for every possible model type. So, yes, it's long.
# rubocop:disable Metrics/ModuleLength

module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that contain other models.

  module Containing

    # Executes the given code block with every model that is a child of this model.
    def each_descendant(&block)
      children.each do |child_model|
        block.call(child_model)
        child_model.each_descendant(&block) if child_model.respond_to?(:each_descendant)
      end
    end

    # Executes the given code block with this model and every model that is a child of this model.
    def each_model(&block)
      block.call(self)

      each_descendant(&block)
    end


    private


    def build_child_model(clazz, model_data)
      model = clazz.new

      tiny_class = clazz.name.match(/::(\w+)/)[1].downcase
      model.send("populate_#{tiny_class}", model, model_data)

      model.parent_model = self

      model
    end

    def populate_scenario(scenario_object, parsed_scenario_data)
      populate_parsing_data(scenario_object, parsed_scenario_data)
      populate_source_line(scenario_object, parsed_scenario_data)
      populate_keyword(scenario_object, parsed_scenario_data)
      populate_name(scenario_object, parsed_scenario_data)
      populate_description(scenario_object, parsed_scenario_data)
      populate_steps(scenario_object, parsed_scenario_data)
      populate_tags(scenario_object, parsed_scenario_data)
    end

    def populate_outline(outline_object, parsed_outline_data)
      populate_parsing_data(outline_object, parsed_outline_data)
      populate_source_line(outline_object, parsed_outline_data)
      populate_keyword(outline_object, parsed_outline_data)
      populate_name(outline_object, parsed_outline_data)
      populate_description(outline_object, parsed_outline_data)
      populate_steps(outline_object, parsed_outline_data)
      populate_tags(outline_object, parsed_outline_data)
      populate_outline_examples(outline_object, parsed_outline_data['examples']) if parsed_outline_data['examples']
    end

    def populate_background(background_object, parsed_background_data)
      populate_parsing_data(background_object, parsed_background_data)
      populate_keyword(background_object, parsed_background_data)
      populate_name(background_object, parsed_background_data)
      populate_description(background_object, parsed_background_data)
      populate_source_line(background_object, parsed_background_data)
      populate_steps(background_object, parsed_background_data)
    end

    def populate_step(step_object, parsed_step_data)
      populate_text(step_object, parsed_step_data)
      populate_block(step_object, parsed_step_data)
      populate_keyword(step_object, parsed_step_data)
      populate_source_line(step_object, parsed_step_data)
      populate_parsing_data(step_object, parsed_step_data)
    end

    def populate_block(step_object, parsed_step_data)
      step_object.block = if parsed_step_data['table']
                            build_child_model(Table, parsed_step_data['table'])
                          elsif parsed_step_data['doc_string']
                            build_child_model(DocString, parsed_step_data['doc_string'])
                          end
    end

    def populate_table(table_object, parsed_table_data)
      populate_row_models(table_object, parsed_table_data)
      populate_parsing_data(table_object, parsed_table_data)
      populate_source_line(table_object, parsed_table_data)
    end

    def populate_cell(cell_object, parsed_cell_data)
      populate_cell_value(cell_object, parsed_cell_data)
      populate_source_line(cell_object, parsed_cell_data)
      populate_parsing_data(cell_object, parsed_cell_data)
    end

    def populate_docstring(doc_string_object, parsed_doc_string_data)
      populate_content_type(doc_string_object, parsed_doc_string_data)
      populate_content(doc_string_object, parsed_doc_string_data)
      populate_parsing_data(doc_string_object, parsed_doc_string_data)
      populate_source_line(doc_string_object, parsed_doc_string_data)
    end

    def populate_example(example_object, parsed_example_data)
      populate_parsing_data(example_object, parsed_example_data)
      populate_keyword(example_object, parsed_example_data)
      populate_source_line(example_object, parsed_example_data)
      populate_name(example_object, parsed_example_data)
      populate_description(example_object, parsed_example_data)
      populate_tags(example_object, parsed_example_data)
      populate_example_rows(example_object, parsed_example_data)
    end

    def populate_row(row_object, parsed_row_data)
      populate_source_line(row_object, parsed_row_data)
      populate_row_cells(row_object, parsed_row_data)
      populate_parsing_data(row_object, parsed_row_data)
    end

    def populate_feature(feature_object, parsed_feature_data)
      populate_parsing_data(feature_object, parsed_feature_data)
      populate_source_line(feature_object, parsed_feature_data)
      populate_keyword(feature_object, parsed_feature_data)
      populate_name(feature_object, parsed_feature_data)
      populate_description(feature_object, parsed_feature_data)
      populate_tags(feature_object, parsed_feature_data)
      populate_children(feature_object, parsed_feature_data)
    end

    def populate_rule(rule_object, parsed_rule_data)
      populate_parsing_data(rule_object, parsed_rule_data)
      populate_source_line(rule_object, parsed_rule_data)
      populate_keyword(rule_object, parsed_rule_data)
      populate_name(rule_object, parsed_rule_data)
      populate_description(rule_object, parsed_rule_data)
      populate_children(rule_object, parsed_rule_data)
    end

    def populate_directory(directory_object, processed_directory_data)
      directory_object.path = processed_directory_data['path']

      processed_directory_data['directories'].each do |directory_data|
        directory_object.directories << build_child_model(Directory, directory_data)
      end

      processed_directory_data['feature_files'].each do |feature_file_data|
        directory_object.feature_files << build_child_model(FeatureFile, feature_file_data)
      end
    end

    def populate_featurefile(feature_file_object, processed_feature_file_data)
      populate_parsing_data(feature_file_object, processed_feature_file_data)
      feature_file_object.path = processed_feature_file_data['path']

      if processed_feature_file_data['feature']
        feature_file_object.feature = build_child_model(Feature, processed_feature_file_data['feature'])
      end

      processed_feature_file_data['comments'].each do |comment_data|
        feature_file_object.comments << build_child_model(Comment, comment_data)
      end
    end

    def populate_tag(tag_object, processed_tag_data)
      populate_name(tag_object, processed_tag_data)
      populate_parsing_data(tag_object, processed_tag_data)
      populate_source_line(tag_object, processed_tag_data)
    end

    def populate_comment(comment_object, processed_comment_data)
      populate_comment_text(comment_object, processed_comment_data)
      populate_parsing_data(comment_object, processed_comment_data)
      populate_source_line(comment_object, processed_comment_data)
    end

    def populate_comment_text(comment_model, parsed_comment_data)
      comment_model.text = parsed_comment_data['text'].strip
    end

    def populate_text(step_model, parsed_step_data)
      step_model.text = parsed_step_data['name']
    end

    def populate_keyword(model, parsed_model_data)
      model.keyword = parsed_model_data['keyword'].strip
    end

    def populate_row_models(table_model, parsed_table_data)
      parsed_table_data['rows'].each do |row_data|
        table_model.rows << build_child_model(Row, row_data)
      end
    end

    def populate_row_cells(row_model, parsed_row_data)
      parsed_row_data['cells'].each do |cell_data|
        row_model.cells << build_child_model(Cell, cell_data)
      end
    end

    def populate_cell_value(cell_model, parsed_cell_data)
      cell_model.value = parsed_cell_data['value']
    end

    def populate_content_type(doc_string_model, parsed_doc_string_data)
      doc_string_model.content_type = parsed_doc_string_data['content_type']
    end

    def populate_content(doc_string_model, parsed_doc_string_data)
      doc_string_model.content = parsed_doc_string_data['value']
    end

    def populate_outline_examples(outline_model, parsed_examples)
      parsed_examples.each do |example_data|
        outline_model.examples << build_child_model(Example, example_data)
      end
    end

    def populate_example_rows(example_model, parsed_example_data)
      parsed_example_data['rows'].each do |row_data|
        example_model.rows << build_child_model(Row, row_data)
      end
    end

    # It's not getting better any time soon
    # rubocop:disable Metrics/AbcSize

    def populate_children(model, parsed_feature_data)
      return unless parsed_feature_data['elements']

      parsed_feature_data['elements'].each do |element|
        case element['type']
          when 'Scenario', 'scenario'
            model.tests << build_child_model(Scenario, element)
          when 'ScenarioOutline', 'scenario_outline'
            model.tests << build_child_model(Outline, element)
          when 'Background', 'background'
            model.background = build_child_model(Background, element)
          when 'Rule'
            model.rules << build_child_model(Rule, element)
          else
            raise(ArgumentError, "Unknown element type: #{element['type']}")
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

  end
end
# rubocop:enable Metrics/ModuleLength
