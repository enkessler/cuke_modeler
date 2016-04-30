require 'spec_helper'

shared_examples_for 'a feature element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a name - #name' do
    element.should respond_to(:name)
  end

  it 'can get and set its name - #name, #name=' do
    expect(element).to respond_to(:name=)

    element.name = :some_name
    element.name.should == :some_name
    element.name = :some_other_name
    element.name.should == :some_other_name
  end

  it 'has a description' do
    element.should respond_to(:description)
    element.should respond_to(:description_text)
  end

  it 'can get and set its description' do
    expect(element).to respond_to(:description=)
    expect(element).to respond_to(:description_text=)

    element.description = :some_description
    element.description.should == :some_description
    element.description = :some_other_description
    element.description.should == :some_other_description

    element.description_text = :some_description
    element.description_text.should == :some_description
    element.description_text = :some_other_description
    element.description_text.should == :some_other_description
  end

  it 'starts with no name' do
    element.name.should == ''
  end

  it 'starts with no description' do
    element.description.should == []
    element.description_text.should == ''
  end

end
