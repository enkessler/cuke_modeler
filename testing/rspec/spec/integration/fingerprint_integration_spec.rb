require "#{File.dirname(__FILE__)}/../spec_helper"
require 'benchmark'

describe 'Fingerprint, Integration' do

  describe '.fingerprint' do

    let(:model) { CukeModeler::Step.new }

    before do
      model.keyword = 'Given'
      model.text = 'I am testing the fingerprint'
    end

    describe 'getting a fingerprint without args' do

      it 'returns the Digest::MD5 of the to_s representation' do
        expect(model.fingerprint).to eq(Digest::MD5.hexdigest(model.to_s))
      end

    end

    describe 'getting a fingerprint with a block' do

      it 'returns the Digest::MD5 of the block return value' do
        fingerprint = model.fingerprint do |m|
          m.text
        end

        expect(fingerprint).to eq(Digest::MD5.hexdigest(model.text))
      end

    end

    describe 'getting a fingerprint with a block that returns nil' do

      it 'returns nil' do
        fingerprint = model.fingerprint do |m|
          nil
        end

        expect(fingerprint).to eq(nil)
      end

    end

    describe 'comparing fingerprints' do

      let(:maximum_viable_gherkin) do
        "@a_tag
         #{SCENARIO_KEYWORD}: test scenario

         Scenario
         description

           #{STEP_KEYWORD} a step
             | value1 |
             | value2 |
           #{STEP_KEYWORD} another step
             \"\"\" with content type
             some text
             \"\"\""
      end

      let(:model_one) { CukeModeler::Scenario.new(maximum_viable_gherkin) }
      let(:model_two) { CukeModeler::Scenario.new(maximum_viable_gherkin) }
      let(:model_three) { CukeModeler::Scenario.new }

      it 'should result in the same fingerprint' do
        expect(model_one.fingerprint).to eq(model_two.fingerprint)
        expect(model_one.fingerprint).not_to eq(model_three.fingerprint)
      end

      it 'is more performant than ==' do
        equals_time = Benchmark.realtime { model_one == model_two }
        fingerprint_time = Benchmark.realtime { model_one.fingerprint == model_two.fingerprint }

        expect(equals_time > fingerprint_time).to eq(true)
      end

    end

  end

end

