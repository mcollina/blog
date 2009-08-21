class Article < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_uniqueness_of :title
  validates_presence_of :user

  belongs_to :user
end
