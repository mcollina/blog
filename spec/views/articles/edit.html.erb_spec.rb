require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/edit.html.erb" do
  include ArticlesHelper
  
  before(:each) do
    assigns[:article] = @article = stub_model(Article,
      :new_record? => false,
      :title => "value for title",
      :content => "value for content"
    )
  end

  it "should render edit form" do
    render "/articles/edit.html.erb"
    
    response.should have_tag("form[action=#{article_path(@article)}][method=post]") do
      with_tag('input#article_title[name=?]', "article[title]")
      with_tag('textarea#article_content[name=?]', "article[content]")
    end
  end
end


