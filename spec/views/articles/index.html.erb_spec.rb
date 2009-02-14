require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/index.html.erb" do
  include ArticlesHelper
  
  before(:each) do
    assigns[:articles] = [
      stub_model(Article,
        :title => "value for title",
        :content => "value for content"
      ),
      stub_model(Article,
        :title => "value for title",
        :content => "value for content"
      )
    ]
  end

  it "should render list of articles" do
    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
  end
end

