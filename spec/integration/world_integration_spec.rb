require 'spec_helper'

SimpleCov.command_name('World') unless RUBY_VERSION.to_s < '1.9.0'

describe 'World, Integration' do

  before(:each) do
    @world = CukeModeler::World
    @world.loaded_step_patterns.clear
  end

  # Nothing left to do here for now.
end
