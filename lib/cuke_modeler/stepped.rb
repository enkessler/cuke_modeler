module CukeModeler

  # A mix-in module containing methods used by elements that have a steps.

  module Stepped


    attr_accessor :steps


    private


    def populate_steps(parsed_background)
      if parsed_background['steps']
        parsed_background['steps'].each do |step|
          @steps << build_child_element(Step, step)
        end
      end
    end

    def steps_output_string
      steps.collect { |step| indented_step_text(step) }.join("\n")
    end

    def indented_step_text(step)
      step.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")
    end

  end
end
