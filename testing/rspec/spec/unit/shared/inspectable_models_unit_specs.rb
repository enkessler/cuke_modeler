require_relative '../../../../../environments/rspec_env'


shared_examples_for 'an inspectable model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'can provide a custom inspection value for itself' do
    expect(model.method(:inspect).owner).to equal(clazz), "#{clazz} does not override #inspect"
  end

  it 'returns a String when inspected' do
    expect(model.inspect).to be_a(String)
  end

end
