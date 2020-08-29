module CukeModeler
  module DialectHelper

    class << self

      attr_writer :dialect

      def feature_keyword
        get_word(@dialect['feature'])
      end

      def background_keyword
        get_word(@dialect['background'])
      end

      def rule_keyword
        get_word(@dialect['rule'])
      end

      def scenario_keyword
        get_word(@dialect['scenario'])
      end

      def outline_keyword
        get_word(@dialect['scenarioOutline'] || @dialect['scenario_outline'])
      end

      def example_keyword
        get_word(@dialect['examples'])
      end

      def step_keyword
        get_word(@dialect['given']).strip
      end

      def given_keyword
        get_word(@dialect['given']).strip
      end

      def then_keyword
        get_word(@dialect['then']).strip
      end

      def get_word(word_set)
        word_set.is_a?(Array) ? word_set.first : word_set.split('|').first
      end

    end

    private_class_method :get_word

  end
end
