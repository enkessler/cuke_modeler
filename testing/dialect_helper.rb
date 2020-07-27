module CukeModeler
  module DialectHelper

    def self.set_dialect(dialect)
      @dialect = dialect
    end

    def self.feature_keyword
      get_word(@dialect['feature'])
    end

    def self.background_keyword
      get_word(@dialect['background'])
    end

    def self.rule_keyword
      get_word(@dialect['rule'])
    end

    def self.scenario_keyword
      get_word(@dialect['scenario'])
    end

    def self.outline_keyword
      get_word(@dialect['scenarioOutline'] || @dialect['scenario_outline'])
    end

    def self.example_keyword
      get_word(@dialect['examples'])
    end

    def self.step_keyword
      get_word(@dialect['given']).strip
    end

    def self.given_keyword
      get_word(@dialect['given']).strip
    end

    def self.then_keyword
      get_word(@dialect['then']).strip
    end

    def self.get_word(word_set)
      word_set.is_a?(Array) ? word_set.first : word_set.split('|').first
    end


    private_class_method :get_word

  end
end
