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

  it 'takes an optional verbosity flag for inspection' do
    expect(model.method(:inspect).parameters).to eq([%i[key verbose]])
  end

  it 'defaults to non-verbose inspection' do
    non_verbose_output = model.inspect(verbose: false)
    default_output     = model.inspect

    expect(non_verbose_output).to eq(default_output)
  end

  context 'with verbosity flagged as false' do
    let(:flag_value) { false }


    it 'outputs the custom inspection output' do
      expected_pattern = if clazz == CukeModeler::Model
                           '#<CukeModeler::<model_class>:<object_id>>'
                         else
                           '#<CukeModeler::<model_class>:<object_id> <some_meaningful_attribute>: <attribute_value>>'
                         end

      output           = model.inspect(verbose: flag_value)
      expected_pattern = expected_pattern.sub('<model_class>', clazz.to_s.match(/CukeModeler::(.*)/)[1])
                                         .sub('<object_id>', '\d+')
                                         .sub('<some_meaningful_attribute>', '@\w+')
                                         .sub('<attribute_value>', '.*')

      expect(output).to match(expected_pattern), "#{clazz} did not provide the custom inspection output"
    end
  end

  context 'with verbosity flagged as true' do
    let(:flag_value) { true }


    it 'outputs the default inspection output' do
      default_method = clazz.ancestors.find { |ancestor| ancestor.name == 'Object' }.instance_method(:inspect)

      output         = model.inspect(verbose: flag_value)
      default_output = default_method.bind(model).call

      expect(output).to eq(default_output), "#{clazz} did not provide the default inspection output"
    end
  end

end
