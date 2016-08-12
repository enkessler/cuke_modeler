require 'spec_helper'


describe 'Nested, Integration' do

  let(:nodule) { CukeModeler::Nested }
  let(:nested_model) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    describe 'an object including the module' do

      describe 'getting ancestors' do

        context 'with a background ancestor' do

          let(:background) { CukeModeler::Background.new }

          before(:each) do
            nested_model.parent_model = background
          end


          it "will find its background as a 'test' ancestor" do
            ancestor = nested_model.get_ancestor(:test)

            expect(ancestor).to equal(background)
          end

          it "will find its background as a 'background' ancestor" do
            ancestor = nested_model.get_ancestor(:background)

            expect(ancestor).to equal(background)
          end

        end

        context 'with a scenario ancestor' do

          let(:scenario) { CukeModeler::Scenario.new }

          before(:each) do
            nested_model.parent_model = scenario
          end


          it "will find its scenario as a 'test' ancestor" do
            ancestor = nested_model.get_ancestor(:test)

            expect(ancestor).to equal(scenario)
          end

          it "will find its scenario as a 'scenario' ancestor" do
            ancestor = nested_model.get_ancestor(:scenario)

            expect(ancestor).to equal(scenario)
          end

        end

        context 'with an outline ancestor' do

          let(:outline) { CukeModeler::Outline.new }

          before(:each) do
            nested_model.parent_model = outline
          end


          it "will find its outline as a 'test' ancestor" do
            ancestor = nested_model.get_ancestor(:test)

            expect(ancestor).to equal(outline)
          end

          it "will find its outline as a 'outline' ancestor" do
            ancestor = nested_model.get_ancestor(:outline)

            expect(ancestor).to equal(outline)
          end

        end

      end

    end

  end

end
