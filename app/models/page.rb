class Page < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_uniqueness_of :title

  #acts_as_list

  default_scope :order => 'position'
  
  def visible?(controller)
    true
  end

  def current?(controller)
    return false unless controller.respond_to? :page
    controller.page == self
  end

  def build_link(controller)
    controller.send(:page_path,self)
  end

  def name
    title
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
