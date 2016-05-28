require 'spec_helper'

shared_examples_for 'a stepped element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has steps' do
    expect(element).to respond_to(:steps)
  end

  it 'can change its steps' do
    expect(element).to respond_to(:steps=)

    element.steps = :some_steps
    expect(element.steps).to eq(:some_steps)
    element.steps = :some_other_steps
    expect(element.steps).to eq(:some_other_steps)
  end

  it 'starts with no steps' do
    expect(element.steps).to eq([])
  end

  it 'contains steps' do
    steps = [:step_1, :step_2, :step_3]
    element.steps = steps

    steps.each { |step| expect(element.children).to include(step) }
  end

end
