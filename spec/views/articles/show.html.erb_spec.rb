require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/show.html.erb" do
  include ArticlesHelper
  before(:each) do
    assigns[:article] = @article = stub_model(Article,
      :title => "value for title",
      :content => "value for content"
    )
  end

  it "should render attributes in <p>" do
    render "/articles/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ content/)
  end
end

