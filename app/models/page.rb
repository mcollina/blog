class Page < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_uniqueness_of :title

  #acts_as_list

  default_scope :order => 'position'
  
  def to_page
    NavigablePage.new(self)
  end

  private
  class NavigablePage

    attr_reader :id
    attr_reader :name

    def initialize(page)
      @id = page.id
      @name = page.title
    end

    def visible?(controller)
      true
    end

    def current?(controller)
      return false if not controller.respond_to? :page or controller.page.nil?
      controller.page.id == id
    end

    def build_link(controller)
      controller.send(:page_path,id)
    end

    def has_subpages?
      false
    end

    def subpages
      []
    end

    def link_options
      Hash.new
    end
  end
end
