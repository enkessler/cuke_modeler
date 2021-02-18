module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that represent an element that has steps.
  module Stepped


    # The step models contained by this model
    attr_accessor :steps


    private


    def steps_output_string
      steps.collect { |step| indented_step_text(step) }.join("\n")
    end

    def indented_step_text(step)
      step.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")
    end

    def populate_steps(model, parsed_model_data)
      return unless parsed_model_data['steps']

      parsed_model_data['steps'].each do |step_data|
        model.steps << build_child_model(Step, step_data)
      end
    end

  end
end
