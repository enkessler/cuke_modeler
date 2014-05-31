require 'spec_helper'

SimpleCov.command_name('World') unless RUBY_VERSION.to_s < '1.9.0'

describe 'World, Integration' do

  before(:each) do
    @world = CukeModeler::World
    @world.loaded_step_patterns.clear
  end

  context 'collecting stuff' do

    before(:each) do
      @patterns = [/a defined step/, /another defined step/]
      @defined_steps = [CukeModeler::Step.new('* a defined step'), CukeModeler::Step.new('* another defined step')]
      @undefined_steps = [CukeModeler::Step.new('* an undefined step'), CukeModeler::Step.new('* another undefined step')]

      @patterns.each do |pattern|
        @world.load_step_pattern(pattern)
      end
    end

    it 'can collect defined steps from containers' do
      nested_container = double(:steps => @defined_steps)
      container = double(:steps => @undefined_steps, :contains => [nested_container])

      @defined_steps.should =~ @world.defined_steps_in(container)
    end

    it 'can collect undefined steps from containers' do
      nested_container = double(:steps => @defined_steps)
      container = double(:steps => @undefined_steps, :contains => [nested_container])

      @undefined_steps.should =~ @world.undefined_steps_in(container)
    end

  end

end
