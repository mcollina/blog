require File.dirname(__FILE__) + "/static_page"

module Navigations
  class Navigator

    attr_reader :pages
    attr_reader :name
  
    def initialize(name=:anonymous)
      @pages = []
      @name = name.to_sym
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
  end
end

