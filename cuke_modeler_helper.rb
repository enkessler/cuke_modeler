require 'childprocess'


module CukeModeler

  # Various helper methods for the project
  module CukeModelerHelper

    module_function

    def run_command(parts)
      parts.unshift('cmd.exe', '/c') if ChildProcess.windows?
      process = ChildProcess.build(*parts)

      process.io.inherit!
      process.start
      process.wait

      process
    end

  end
end
