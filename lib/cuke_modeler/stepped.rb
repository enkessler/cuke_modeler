module CukeModeler

  # A mix-in module containing methods used by models that represent an element that has steps.

  module Stepped


    attr_accessor :steps


    private


    def steps_output_string
      steps.collect { |step| indented_step_text(step) }.join("\n")
    end

    def indented_step_text(step)
      step.to_s.split("\n").collect { |line| "  #{line}" }.join("\n")
    end

  end
end
