require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    Page.create!(@valid_attributes)
  end

  it "should update the updated_at field after any modification" do
    creation_time = Time.now
    page = Page.create!(@valid_attributes)
    page.updated_at.should > creation_time

    update_time = Time.now
    page.title = "hello world"
    page.save!
    page.updated_at.should > update_time
  end

  it "should validate the presence of the title" do
    page = Page.new(:content => "hello world")
    page.save.should be_false
  end

  it "should validate the presence of the content" do
    page = Page.new(:title => "hello world")
    page.save.should be_false
  end

  it "should have a unique title" do
    Page.create!(@valid_attributes)
    lambda {
      Page.create!(@valid_attributes)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
