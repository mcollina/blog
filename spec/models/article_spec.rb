require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :content => "value for content",
      :user => mock_model(User, :id => 42)
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
    @valid_attributes.delete(:title)
    article = Article.new(@valid_attributes)
    article.save.should be_false
  end

  it "should validate the presence of the content" do
    @valid_attributes.delete(:content)
    article = Article.new(@valid_attributes)
    article.save.should be_false
  end

  it "should have a unique title" do
    Article.create!(@valid_attributes)
    lambda {
      Article.create!(@valid_attributes)
    }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should validate the presence of the user" do
    @valid_attributes.delete(:user)
    article = Article.new(@valid_attributes)
    article.save.should be_false
  end

  it "should have a title" do
    article = Article.new(@valid_attributes)
    article.should respond_to(:title)
    article.should respond_to(:title=)

    article.title.should == @valid_attributes[:title]
    article.title = "gh"
    article.title.should == "gh"
  end

  it "should have a content" do
    article = Article.new(@valid_attributes)
    article.should respond_to(:content)
    article.should respond_to(:content=)

    article.content.should == @valid_attributes[:content]
    article.content = "gh"
    article.content.should == "gh"
  end

  it "should have a User" do
    article = Article.new(@valid_attributes)
    article.should respond_to(:user)
    article.should respond_to(:user=)

    article.user.should == @valid_attributes[:user]

    user = mock_model(User, :id => 57)
    article.user = user
    article.user.should == user
  end
end
