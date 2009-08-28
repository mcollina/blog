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

  it "should respond to to_page" do
    page = Page.new(@valid_attributes)
    page.should respond_to(:to_page)
  end

  describe "#to_page" do

    it_should_behave_like "a navigable page"

    before :each do
      @active_record_page = Page.create!(@valid_attributes)
      @instance = @active_record_page.to_page
    end

    it "should create a non-activerecord page model" do
      @instance.should_not be_kind_of(ActiveRecord::Base)
    end

    it "should be current if the controller has a page method and that page is the original page" do
      controller = mock "Controller"
      controller.should_receive(:respond_to?).with(:page).and_return(true)
      controller.should_receive(:page).at_least(1).and_return(@active_record_page)

      @instance.should be_current(controller)
    end

    it "should not be current if the controller has a page method and that page is nil" do
      controller = mock "Controller"
      controller.should_receive(:respond_to?).with(:page).and_return(true)
      controller.should_receive(:page).at_least(1).and_return(nil)

      @instance.should_not be_current(controller)
    end

    it "should not be current if the controller hasn't got a page method" do
      controller = mock "Controller"
      controller.should_receive(:respond_to?).with(:page).and_return(false)

      @instance.should_not be_current(controller)
    end

    it "should not be current if the controller's page isn't the navigation page" do
      controller = mock "Controller"
      controller.should_receive(:respond_to?).with(:page).and_return(true)

      page = mock "Page"
      page.should_receive(:id).and_return(@active_record_page.id + 1)
      controller.should_receive(:page).at_least(1).and_return(page)

      @instance.should_not be_current(controller)
    end

    it "should alwasy be visible" do
      @instance.should be_visible(mock "controller")
    end


    it "should correctly build its link" do
      controller = mock "Controller"
      controller.should_receive(:send).with(:page_path,@active_record_page.id).and_return("/path/to/page")
      @instance.build_link(controller).should == "/path/to/page"
    end

    it "should alias the title as name" do
      @instance.name.should == @valid_attributes[:title]
    end
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
