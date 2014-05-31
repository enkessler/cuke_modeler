require 'spec_helper'

SimpleCov.command_name('World') unless RUBY_VERSION.to_s < '1.9.0'

describe 'World, Unit' do

  before(:each) do
    @world = CukeModeler::World
    @world.loaded_step_patterns.clear
    @world.delimiter = nil
  end

  it 'has left and right delimiters used for step argument parsing - #left_delimiter, #right_delimiter' do
    @world.should respond_to(:left_delimiter)
    @world.should respond_to(:right_delimiter)
  end

  it 'can get and set the delimiters used for step argument parsing' do
    @world.left_delimiter = '"'
    @world.right_delimiter = '"'
    @world.left_delimiter.should == '"'
    @world.right_delimiter.should == '"'

    @world.left_delimiter = '!'
    @world.right_delimiter = '!'
    @world.left_delimiter.should == '!'
    @world.right_delimiter.should == '!'
  end

  it 'can have different left and right delimiters' do
    @world.left_delimiter = '"'
    @world.right_delimiter = '*'

    (@world.left_delimiter != @world.right_delimiter).should be_true
  end

  it 'can set both of its delimiters at once - #delimiter=' do
    @world.delimiter = '*'

    @world.left_delimiter.should == '*'
    @world.right_delimiter.should == '*'
  end

  it 'starts with no delimiters' do
    @world.left_delimiter.should == nil
    @world.right_delimiter.should == nil
  end

  context 'step patterns' do

    it 'can load step patterns - #load_step_pattern' do
      @world.should respond_to(:load_step_pattern)
    end

    it 'starts with no patterns loaded' do
      @world.loaded_step_patterns.should == []
    end

    it 'keeps track of loaded step patterns - #loaded_step_patterns' do
      patterns = [/a pattern/, /another pattern/]

      patterns.each do |pattern|
        @world.load_step_pattern(pattern)
      end

      @world.loaded_step_patterns.should =~ patterns
    end

    it 'can load step definition files - #load_step_file' do
      file_path = "#{@default_file_directory}/step_file.rb"
      patterns = [/a pattern/, /another pattern/]

      File.open(file_path, 'w') { |file|
        patterns.each do |pattern|
          file.puts "Given #{pattern.inspect} do end"
        end
      }

      @world.load_step_file(file_path)

      @world.loaded_step_patterns.should =~ patterns
    end

    it 'can handle different step keywords - #load_step_file' do
      file_path = "#{@default_file_directory}/step_file.rb"
      patterns = [/given pattern/, /when pattern/, /then pattern/, /and pattern/, /but pattern/]

      File.open(file_path, 'w') { |file|
        file.puts "Given #{patterns[0].inspect} do end"
        file.puts "When #{patterns[1].inspect} do end"
        file.puts "Then #{patterns[2].inspect} do end"
        file.puts "And #{patterns[3].inspect} do end"
        file.puts "But #{patterns[4].inspect} do end"
      }

      @world.load_step_file(file_path)

      @world.loaded_step_patterns.should =~ patterns
    end

    it 'can handle a variety of declaration structures - #load_step_file' do
      file_path = "#{@default_file_directory}/step_file.rb"
      patterns = [/parentheses pattern/, /no parentheses pattern/, /excess whitespace pattern/]

      File.open(file_path, 'w') { |file|
        file.puts "Given(#{patterns[0].inspect}) do end"
        file.puts "Given #{patterns[1].inspect} do end"
        file.puts "Given   #{patterns[2].inspect}   do end"
      }

      @world.load_step_file(file_path)

      @world.loaded_step_patterns.should =~ patterns
    end

    it 'can clear its loaded step patterns - #clear_step_patterns' do
      patterns = [/a pattern/, /another pattern/]

      patterns.each do |pattern|
        @world.load_step_pattern(pattern)
      end

      @world.loaded_step_patterns.should =~ patterns
      @world.clear_step_patterns
      @world.loaded_step_patterns.should == []
    end

  end

end
