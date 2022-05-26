require 'childprocess'


module CukeModeler

  # Various helper methods for the project
  module CukeModelerHelper

    module_function

    def major_version_of(gem_name)
      Gem.loaded_specs[gem_name].version.version.match(/^(\d+)\./)[1].to_i
    end

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
