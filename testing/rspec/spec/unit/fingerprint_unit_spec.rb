require "#{File.dirname(__FILE__)}/../spec_helper"

describe 'Fingerprint, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Fingerprint }
  let(:fingerprint_model) { Object.new.extend(nodule) }


  it 'has a fingerprint' do
    expect(model).to respond_to(:fingerprint)
  end
end
