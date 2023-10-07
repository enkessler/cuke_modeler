require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a stringifiable model, integration' do

  # clazz must be defined by the calling file

  it 'can be remade from its own stringified output' do
    # Because the base model class's string output is undefined, it can't be reliably
    # remade from its own output
    unless clazz == CukeModeler::Model
      count = 0

      # Check for all defined maximal strings in the test file (i.e. maximal_string_input_N)
      loop do
        count += 1

        # Having more than one maximal string is rare enough that it looks nicer in the test
        # files if we don't have to use '1' for the most common case
        source = count == 1 ? 'maximal_string_input' : "maximal_string_input_#{count}"
        model  = clazz.new(send(source))

        model_output        = model.to_s
        remade_model_output = clazz.new(model_output).to_s

        expect(remade_model_output).to eq(model_output)

        break unless respond_to?("maximal_string_input_#{count + 1}")
      end
    end
  end

end
