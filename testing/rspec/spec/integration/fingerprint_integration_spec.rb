require "#{File.dirname(__FILE__)}/../spec_helper"

describe 'Fingerprint, Integration' do

  describe 'unique behavior' do

    describe 'An object without children' do

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
    end

    describe 'An object with children' do

      let(:model) { CukeModeler::Scenario.new }
      before do
        model.name = 'Testing the fingerprint'

        model.steps = 3.times.map do |i|
          step = CukeModeler::Step.new
          step.keyword = 'When'
          step.text = "Step #{i}"
          step
        end

        model.tags = 2.times.map do |i|
          tag = CukeModeler::Tag.new
          tag.name = "Tag #{i}"
          tag
        end
      end

      describe 'getting a fingerprint without args' do

        it 'returns the Digest::MD5 of the to_s representation of its children' do
          children_fingerprints = model.children.map(&:fingerprint)

          expect(children_fingerprints.compact.count)
            .to eq(children_fingerprints.count)

          expect(model.fingerprint).to eq(Digest::MD5.hexdigest(children_fingerprints.join))
        end

      end


      describe 'getting a fingerprint with a block' do

        it 'returns the Digest::MD5 of the block return value' do
          block = lambda do |m|
            if m.respond_to?(:name)
              m.name
            elsif m.respond_to?(:text)
              m.text
            else
              m.to_s
            end
          end

          children_values = [*model.steps.map(&:text), *model.tags.map(&:name)]
          children_fingerprints = children_values.map { |v| Digest::MD5.hexdigest(v) }

          fingerprint = model.fingerprint(&block)

          expect(fingerprint).to eq(Digest::MD5.hexdigest(children_fingerprints.join))
        end

      end
    end
  end
end

