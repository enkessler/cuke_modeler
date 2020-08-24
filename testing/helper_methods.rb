module CukeModeler
  module HelperMethods

    def assert_bidirectional_equality(base_thing, compared_thing)
      expect(base_thing).to eq(compared_thing)
      expect(compared_thing).to eq(base_thing)
    end

    def assert_bidirectional_inequality(base_thing, compared_thing)
      expect(base_thing).to_not eq(compared_thing)
      expect(compared_thing).to_not eq(base_thing)
    end

    def gherkin?(*versions)
      versions.include?(gherkin_major_version)
    end

    def gherkin_major_version
      Gem.loaded_specs['cucumber-gherkin'].version.version.match(/^(\d+)\./)[1].to_i
    end

    def self.test_storage
      @test_storage ||= {}
    end

  end
end
