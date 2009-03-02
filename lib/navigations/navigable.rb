
module Navigations
  module Navigable
    def self.included(klass)
      super
      klass.extend(ClassMethods)
      klass.instance_variable_set(:@navigator, Navigator.new)
    end

    def navigator
      self.class.navigator
    end

    module ClassMethods
      def inherited(klass)
        super
        klass.send(:include,Navigable)
      end

      def navigator
        @navigator
      end
    end
  end
end
