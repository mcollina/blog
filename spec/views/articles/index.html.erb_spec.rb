require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/index.html.erb" do
  include ArticlesHelper

  def mock_search(current_page, last_page=current_page)
    search = mock "Search"

    first_page = 0
    next_page = current_page + 1
    prev_page = current_page - 1

    search.should_receive(:last_page).at_least(1).and_return(last_page)
    search.should_receive(:next_page).at_least(1).and_return(next_page)
    search.should_receive(:prev_page).at_least(1).and_return(prev_page)
    search.should_receive(:first_page).at_least(1).and_return(first_page)

    search
  end

  def mock_page_link(template, page, hash)
    template.should_receive(:page_link).with(page, hash).and_return("<a>#{hash[:text]}</a>")
  end

  before(:each) do
    assigns[:articles] = [
      stub_model(Article,
        :title => "value for title",
        :content => "<p>value for content</p>"
      ),
      stub_model(Article,
        :title => "value for title",
        :content => "<p>value for content</p>"
      )
    ]
  end

  it "should render list of articles if there are no more pages" do
    #we're on the first page and there are no more pages
    assigns[:search] = mock_search(0)

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should_not have_tag("a", "Previous Articles")
    response.should_not have_tag("a", "Following Articles")
  end

  it "should display the 'Previous Articles' link if there are more pages after this one" do
    assigns[:search] = mock_search(0,1)
    mock_page_link(template, 1, :text => "Previous Articles", :html => {:class => "floatRight"})

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should have_tag("a", "Previous Articles")
    response.should_not have_tag("a", "Following Articles")
  end

  it "should display the 'Previous Articles' link if there are more pages before this one" do
    assigns[:search] = mock_search(1,1)
    mock_page_link(template, 0, :text => "Following Articles", :html => {:class => "floatLeft"})

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should_not have_tag("a", "Previous Articles")
    response.should have_tag("a", "Following Articles")
  end
end

