require 'spec_helper'

shared_examples_for 'a stepped model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has steps' do
    expect(model).to respond_to(:steps)
  end

  it 'can change its steps' do
    expect(model).to respond_to(:steps=)

    model.steps = :some_steps
    expect(model.steps).to eq(:some_steps)
    model.steps = :some_other_steps
    expect(model.steps).to eq(:some_other_steps)
  end


  describe 'abstract instantiation' do

    context 'a new stepped object' do

      let(:model) { clazz.new }


      it 'starts with no steps' do
        expect(model.steps).to eq([])
      end

    end

  end

  it 'contains steps' do
    steps = [:step_1, :step_2, :step_3]
    model.steps = steps

    steps.each { |step| expect(model.children).to include(step) }
  end

end
