require_relative '../../../../environments/rspec_env'


RSpec.describe 'the gem' do

  let(:lib_folder) { "#{@root_dir}/lib" }
  let(:features_folder) { "#{@root_dir}/testing/cucumber/features" }

  before(:all) do
    @root_dir = "#{__dir__}/../../../.."

    # Doing this as a one time hook instead of using `let` in order to reduce I/O time during testing.
    @gemspec = eval(File.read("#{@root_dir}/cuke_modeler.gemspec"))
  end


  it 'validates cleanly' do
    in_stream = StringIO.new
    out_stream = StringIO.new
    error_stream = StringIO.new
    mock_ui = Gem::StreamUI.new(in_stream, out_stream, error_stream)

    Gem::DefaultUserInteraction.use_ui(mock_ui) { @gemspec.validate }

    expect(error_stream.string).to_not match(/warn/i)
  end

  it 'is named correctly' do
    expect(@gemspec.name).to eq('cuke_modeler')
  end

  it 'runs on Ruby' do
    expect(@gemspec.platform).to eq(Gem::Platform::RUBY)
  end

  it 'exposes its "lib" folder' do
    expect(@gemspec.require_paths).to match_array(['lib'])
  end

  it 'has a version' do
    expect(@gemspec.version.version).to eq(CukeModeler::VERSION)
  end

  it 'lists major authors' do
    expect(@gemspec.authors).to match_array(['Eric Kessler'])
  end

  it 'has contact emails for active maintainers' do
    expect(@gemspec.email).to match_array(['morrow748@gmail.com'])
  end

  it 'has a homepage' do
    expect(@gemspec.homepage).to eq('https://github.com/enkessler/cuke_modeler')
  end

  it 'has a summary' do
    text = <<-TEXT
      A gem providing functionality to model Gherkin based test suites.
    TEXT
           .strip.squeeze(' ').delete("\n")

    expect(@gemspec.summary).to eq(text)
  end

  it 'has a description' do
    text = <<-TEXT
      This gem facilitates modeling a test suite that is written in Gherkin (e.g. Cucumber,
      SpecFlow, Lettuce, etc.). It does this by providing an abstraction layer on top of the
      Abstract Syntax Tree that the 'cucumber-gherkin' gem generates when parsing features,
      as well as providing models for feature files and directories in order to be able to
      have a fully traversable model tree of a test suite's structure. These models can then
      be analyzed or manipulated more easily than the underlying AST layer.
    TEXT
           .strip.squeeze(' ').delete("\n")

    expect(@gemspec.description).to eq(text)
  end


  describe 'license' do

    before(:all) do
      # Doing this as a one time hook instead of using `let` in order to reduce I/O time during testing.
      @license_text = File.read("#{@root_dir}/LICENSE.txt")
    end

    it 'has a current license' do
      expect(@license_text).to match(/Copyright.*2014-#{Time.now.year}/)
    end

    it 'uses the MIT license' do
      expect(@license_text).to include('MIT License')
      expect(@gemspec.licenses).to match_array(['MIT'])
    end

  end


  describe 'metadata' do

    it 'links to the changelog' do
      expect(@gemspec.metadata['changelog_uri']).to eq('https://github.com/enkessler/cuke_modeler/blob/master/CHANGELOG.md')
    end

    it 'links to the known issues/bugs' do
      expect(@gemspec.metadata['bug_tracker_uri']).to eq('https://github.com/enkessler/cuke_modeler/issues')
    end

    it 'links to the source code' do
      expect(@gemspec.metadata['source_code_uri']).to eq('https://github.com/enkessler/cuke_modeler')
    end

    it 'links to the gem documentation' do
      expect(@gemspec.metadata['documentation_uri']).to eq('https://www.rubydoc.info/gems/cuke_modeler')
    end

    it 'has two-factor authentication enabled' do
      expect(@gemspec.metadata['rubygems_mfa_required']).to eq('true')
    end

  end


  describe 'included files' do

    it 'does not include files that are not source controlled' do
      bad_file_1 = File.absolute_path("#{lib_folder}/foo.txt")
      bad_file_2 = File.absolute_path("#{features_folder}/foo.txt")

      begin
        FileUtils.touch(bad_file_1)
        FileUtils.touch(bad_file_2)

        gem_files = @gemspec.files.map { |file| File.absolute_path(file) }

        expect(gem_files).to_not include(bad_file_1, bad_file_2)
      ensure
        FileUtils.rm([bad_file_1, bad_file_2])
      end
    end

    it 'does not include just any source controlled file' do
      some_files_not_to_include = ['Gemfile', 'Rakefile']

      some_files_not_to_include.each do |file|
        expect(@gemspec.files).to_not include(file)
      end
    end

    it 'includes all of the library files' do
      lib_files = Dir.chdir(@root_dir) do
        Dir.glob('lib/**/*').reject { |file| File.directory?(file) }
      end

      expect(@gemspec.files).to include(*lib_files)
    end

    it 'includes all of the documentation files' do
      feature_files = Dir.chdir(@root_dir) do
        Dir.glob('testing/cucumber/features/**/*').reject { |file| File.directory?(file) }
      end

      expect(@gemspec.files).to include(*feature_files)
    end

    it 'includes the README file' do
      readme_file = 'README.md'

      expect(@gemspec.files).to include(readme_file)
    end

    it 'includes the license file' do
      license_file = 'LICENSE.txt'

      expect(@gemspec.files).to include(license_file)
    end

    it 'includes the CHANGELOG file' do
      changelog_file = 'CHANGELOG.md'

      expect(@gemspec.files).to include(changelog_file)
    end

    it 'includes the gemspec file' do
      gemspec_file = 'cuke_modeler.gemspec'

      expect(@gemspec.files).to include(gemspec_file)
    end

  end


  describe 'dependencies' do

    it 'works with Ruby 2 and 3' do
      ruby_version_limits = @gemspec.required_ruby_version.requirements.map(&:join)

      expect(ruby_version_limits).to match_array(['>=2.3', '<4.0'])
    end

    it 'works with Gherkin 9-34' do
      cucumber_gherkin_version_limits = @gemspec.dependencies
                                                .find do |dependency|
                                                  (dependency.type == :runtime) &&
                                                    (dependency.name == 'cucumber-gherkin')
                                                end
                                                .requirement.requirements.map(&:join)

      # NOTE: No lower bound is specified because 9.x was the first release of the gem
      expect(cucumber_gherkin_version_limits).to match_array(['<35.0'])
    end

  end

end


RSpec.describe CukeModeler do

  it 'has a version number' do
    expect(CukeModeler::VERSION).not_to be nil
  end

end
