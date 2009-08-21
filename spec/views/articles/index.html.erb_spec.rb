require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/articles/index.html.erb" do
  include ArticlesHelper

  def mock_search(search, current_page, last_page=current_page)

    if(current_page != last_page)
      next_page = current_page + 1
    else
      next_page = nil
    end

    if(current_page != 0)
      prev_page = current_page - 1
    else
      prev_page = nil
    end

    search.should_receive(:next_page).at_least(1).and_return(next_page)
    search.should_receive(:previous_page).at_least(1).and_return(prev_page)

    search
  end

  before(:each) do
    assigns[:articles] = [
      stub_model(Article,
        :title => "value for title",
        :content => "<p>value for content</p>",
        :user => stub_model(User, :login => "user")
      ),
      stub_model(Article,
        :title => "value for title",
        :content => "<p>value for content</p>",
        :user => stub_model(User, :login => "user")
      )
    ]
  end

  it "should render list of articles if there are no more pages" do
    #we're on the first page and there are no more pages
    assigns[:search] = mock_search(assigns[:articles], 0)

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", /user/, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should_not have_tag("a", "Previous Articles")
    response.should_not have_tag("a", "Following Articles")
  end

  it "should display the 'Previous Articles' link if there are more pages after this one" do
    assigns[:search] = mock_search(assigns[:articles], 0, 1)

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", /user/, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should have_tag("a.floatRight", "Previous Articles")
    response.should_not have_tag("a", "Following Articles")
  end

  it "should display the 'Previous Articles' link if there are more pages before this one" do
    assigns[:search] = mock_search(assigns[:articles], 1, 1)

    render "/articles/index.html.erb"
    response.should have_tag("div>h1", "value for title".to_s, 2)
    response.should have_tag("div>p", /user/, 2)
    response.should have_tag("div>p", "value for content".to_s, 2)
    response.should_not have_tag("a", "Previous Articles")
    response.should have_tag("a.floatLeft", "Following Articles")
  end
end

