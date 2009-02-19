require File.dirname(__FILE__) + "/static_page"
require File.dirname(__FILE__) + "/dynamic_page_factory"

module Navigations
  class Navigator

    attr_reader :name
  
    def initialize(name=:anonymous)
      @pages = []
      @name = name.to_sym
      @contains_factory = false
    end

    # page(name, controller) => self
    # page(&block) yields StaticPage.new => self
    def page(*args,&block)
      if args.size != 2 and block.nil?
        raise ArgumentError.new("You should pass a name and a controller or a block to Navigator#page.")
      end

      name = args.shift
      controller = args.shift

      page = StaticPage.new
      page.name = name unless name.nil?
      page.controller = controller unless controller.nil?

      block.call(page) if block
      
      @pages << page
      self
    end

    def page_factory(factory)
      unless factory.respond_to?(:expand)
        raise ArgumentError.new("The factory should have an expand method")
      end

      @pages << factory
      @contains_factory = true
      self
    end

    def pages
      return @pages.clone unless @contains_factory

      pages = @pages.map do |p|
        if p.respond_to? :expand
          p.expand
        else
          p
        end
      end

      pages.flatten!
    end
  end
end

