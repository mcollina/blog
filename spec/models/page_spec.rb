require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.dirname(__FILE__) + '/shared_page_spec'

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

  it "should have a position" do
    page = Page.new(@valid_attributes)
    lambda {
      page.position = 5
      page.position.should == 5
    }.should_not raise_error
  end

  it "should alias the title as name" do
    page = Page.new(@valid_attributes)
    page.should respond_to(:name)
    page.name.should == @valid_attributes[:title]
  end
end

describe Page, " (initialized)" do
  
  it_should_behave_like "a navigable page"

  before(:each) do
    @instance = Page.create!(
      :title => "value for title",
      :content => "value for content"
    )
  end

  it "should alwasy be visible" do
    @instance.should be_visible(mock "controller")
  end

  it "should correctly build its link" do
    controller = mock "Controller"
    controller.should_receive(:send).with(:page_path,@instance).and_return("/path/to/page")
    @instance.build_link(controller).should == "/path/to/page"
  end

  it "should be current if the controller has this object as its page" do
    controller = mock "PagesController"
    controller.should_receive(:respond_to?).with(:page).and_return(true)
    controller.should_receive(:page).and_return(Page.find(@instance.id))
    @instance.should be_current(controller)
  end

  it "shouldn't be current if the controller has no page" do
    controller = mock "PagesController"
    controller.should_receive(:respond_to?).with(:page).and_return(false)
    @instance.should_not be_current(controller)
  end

  it "shouldn't be current if the controller has another page as its page" do
    controller = mock "PagesController"
    controller.should_receive(:respond_to?).with(:page).and_return(true)
    page = mock "AnotherPage"
    page.should_receive(:==).with(@instance).and_return(false)
    controller.should_receive(:page).and_return(page)
    @instance.should_not be_current(controller)
  end
end

describe Page, " class methods" do
  before(:each) do
    @first = Page.create!(
      :title => "first page title",
      :content => "first page content",
      :position => 2
    )

    @second = Page.create!(
      :title => "second page title",
      :content => "second page content",
      :position => 1
    )

    @third = Page.create!(
      :title => "third page title",
      :content => "third page content",
      :position => 3
    )
  end

  it "should return the pages in order by position" do
    Page.find(:all).should == [@second,@first,@third]
  end

end
