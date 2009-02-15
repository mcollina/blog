require File.dirname(__FILE__) + "/page"

module Navigations
  class Navigator

    attr_reader :pages
    attr_reader :name
  
    def initialize(name)
      @pages = []
      @name = name.to_sym
    end
  
    def add_page(name, controller)
      page = Page.new
      page.name = name
      page.controller = controller
      @pages << page
      self
    end
  end
end

