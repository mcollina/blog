require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_page')

describe "/layouts/_top_menu.html.erb" do

  before(:each) do

    navigator = mock "navigator"
    Navigations::Repository.stub!(:get).and_return(navigator)

    navigator.should_receive(:pages).and_return(
      [
        mock_page(:name => "First Page", :visible => true, :current => false, :link => "/first/page"),
        mock_page(:name => "Second Page", :visible => true, :current => true, :link => "/second/page"),
        mock_page(:name => "Third Page", :visible => false)
      ]
    )
  end

  it "should render list of visible pages" do
    render "/layouts/_top_menu.html.erb"
    response.should have_tag("ul>li>a", "First Page")
    response.should have_tag("ul>li>a", "Second Page")
    response.should_not have_tag("ul>li>a", "Third Page")
  end

  it "should render the current page with class 'here'" do
    render "/layouts/_top_menu.html.erb"
    response.should have_tag("a[class='here']", "Second Page")
  end
end

