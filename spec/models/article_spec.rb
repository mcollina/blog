require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    Article.create!(@valid_attributes)
  end

  it "should set created_at field after creation" do
    current = Time.now
    article = Article.create!(@valid_attributes)
    article.created_at.should > current
  end

  it "should update the updated_at field after any modification" do
    creation_time = Time.now
    article = Article.create!(@valid_attributes)
    article.updated_at.should > creation_time

    update_time = Time.now
    article.title = "hello world"
    article.save!
    article.updated_at.should > update_time
  end

  it "should validate the presence of the title" do
    article = Article.new(:content => "hello world")
    article.save.should be_false
  end

  it "should validate the presence of the content" do
    article = Article.new(:title => "hello world")
    article.save.should be_false
  end

  it "should have a unique title" do
    Article.create!(@valid_attributes)
    lambda {
      Article.create!(@valid_attributes)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
