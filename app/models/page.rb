class Page < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_uniqueness_of :title

  acts_as_list

  def visible?(controller)
    true
  end

  def current?(controller)
    return false unless controller.respond_to? :page
    controller.page == self
  end

  def link(controller)
    controller.send(:page_path,self)
  end

  def name
    title
  end
end
