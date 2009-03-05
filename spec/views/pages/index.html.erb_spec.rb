require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:pages] = [
      stub_model(Page,
        :title => "first value for title",
        :content => "value for content"
      ),
      stub_model(Page,
        :title => "second value for title",
        :content => "value for content"
      )
    ]
  end

  it "should render list of pages" do
    render "/pages/index.html.erb"
    response.should have_tag("ul") do
      with_tag("li",/.*first value for title/)
      with_tag("li",/.*second value for title/)
    end
  end
end

