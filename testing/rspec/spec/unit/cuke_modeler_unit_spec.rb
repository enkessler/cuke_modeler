require_relative '../../../../environments/rspec_env'


RSpec.describe 'the gem' do

  let(:root_dir) { "#{__dir__}/../../../.." }
  let(:gemspec) { eval(File.read("#{root_dir}/cuke_modeler.gemspec")) }
  let(:lib_folder) { "#{root_dir}/lib" }
  let(:features_folder) { "#{root_dir}/testing/cucumber/features" }


  it 'validates cleanly' do
    mock_ui = Gem::MockGemUi.new
    Gem::DefaultUserInteraction.use_ui(mock_ui) { gemspec.validate }

    expect(mock_ui.error).to_not match(/warn/i)
  end


  describe 'included files' do

    it 'does not include files that are not source controlled' do
      bad_file_1 = File.absolute_path("#{lib_folder}/foo.txt")
      bad_file_2 = File.absolute_path("#{features_folder}/foo.txt")

      begin
        FileUtils.touch(bad_file_1)
        FileUtils.touch(bad_file_2)

        gem_files = gemspec.files.map { |file| File.absolute_path(file) }

        expect(gem_files).to_not include(bad_file_1, bad_file_2)
      ensure
        FileUtils.rm([bad_file_1, bad_file_2])
      end
    end

    it 'includes all of the library files' do
      lib_files = Dir.chdir(root_dir) do
        Dir.glob('lib/**/*').reject { |file| File.directory?(file) }
      end

      expect(gemspec.files).to include(*lib_files)
    end

    it 'includes all of the documentation files' do
      feature_files = Dir.chdir(root_dir) do
        Dir.glob('testing/cucumber/features/**/*').reject { |file| File.directory?(file) }
      end

      expect(gemspec.files).to include(*feature_files)
    end

    it 'includes the README file' do
      readme_file = 'README.md'

      expect(gemspec.files).to include(readme_file)
    end

    it 'includes the license file' do
      license_file = 'LICENSE.txt'

      expect(gemspec.files).to include(license_file)
    end

    it 'includes the CHANGELOG file' do
      changelog_file = 'CHANGELOG.md'

      expect(gemspec.files).to include(changelog_file)
    end

    it 'includes the gemspec file' do
      gemspec_file = 'cuke_modeler.gemspec'

      expect(gemspec.files).to include(gemspec_file)
    end

  end

end


RSpec.describe CukeModeler do

  it 'has a version number' do
    expect(CukeModeler::VERSION).not_to be nil
  end

end
