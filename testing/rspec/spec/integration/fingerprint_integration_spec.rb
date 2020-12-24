require "#{File.dirname(__FILE__)}/../spec_helper"

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

  end

end

