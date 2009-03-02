module Navigations
  class StaticPage

    attr_accessor :link_to_eval
    
    attr_accessor :translatable_name
    alias :t_name :translatable_name
    alias :t_name= :translatable_name=

    attr_writer :link

    def name=(name)
      unless name.respond_to?(:to_str)
        raise ArgumentError.new("The page name should be a string")
      end
      @name = name
    end

    def name
      if not @name.nil?
        return @name
      elsif not @translatable_name.nil?
        return I18n.t @translatable_name
      end
    end

    def controller
      if @controller.respond_to?(:to_str)
        @controller = eval(@controller.to_str)
        if @controller.kind_of? Class
          validate(@controller)
        else
          raise "The controller should be a class."
        end
      end

      @controller
    end

    def controller=(controller)
      validate(controller)
      @controller = controller
    end

    def current?(current_controller)
      current_controller = current_controller.class unless current_controller.kind_of? Class
      return current_controller.name == controller.name #this work even in development mode
    end

    def link(controller)
      if not @link.nil?
        @link
      elsif not link_to_eval.nil? and not controller.nil?
        eval(link_to_eval, controller.send(:binding))
      else
        nil
      end
    end

    def visible?(controller)
      unless @visible_block.nil?
        @visible_block.call controller
      else
        true
      end
    end

    def visible_block(&block)
      @visible_block = block
    end

    private
    def validate(controller)
      if controller.kind_of?(Class) and not controller.ancestors.include?(ApplicationController)
        raise ArgumentError.new("The controller for the page #{name} should be a class object" +
            " descending from ApplicationController.")
      end
    end
  end
end
