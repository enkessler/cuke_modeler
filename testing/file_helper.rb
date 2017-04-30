require 'tempfile'


module CukeModeler
  module FileHelper

    def self.create_feature_file(text = "#{CukeModeler::DialectHelper.feature_keyword}:", name = 'test_file', directory = nil)
      create_file(text, name, '.feature', directory)
    end

    def self.create_file(text = '', name = 'test_file', extension = '.txt', directory = nil)
      directory ||= Dir::tmpdir

      temp_file = Tempfile.new([name, extension], directory)
      File.open(temp_file.path, 'w') { |file| file.write(text) }

      temp_file
    end

  end
end
