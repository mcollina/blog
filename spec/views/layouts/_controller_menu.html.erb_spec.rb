require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/mock_page')

describe "/layouts/_controller_menu.html.erb" do

  before(:each) do
    @navigator = mock "navigator"
    @navigator.should_receive(:pages).and_return(
      [
        mock_page(:name => "First Page", :visible => true, :current => false, :link => "/first/page"),
        mock_page(:name => "Second Page", :visible => true, :current => true),
        mock_page(:name => "Third Page", :visible => false)
      ]
    )
    @navigator.should_receive(:empty?).and_return(false)

    @controller.should_receive(:navigator).any_number_of_times.and_return(@navigator)
  end

  it "should render list of visible not current pages" do
    render "/layouts/_controller_menu.html.erb"
    response.should have_tag("ul>li>a", "First Page")
    response.should_not have_tag("ul>li>a", "Second Page")
    response.should_not have_tag("ul>li>a", "Third Page")
  end

  it "should render the current page with class 'here'" do
    render "/layouts/_controller_menu.html.erb"
    response.should have_tag("li[class='here']", "Second Page")
  end
end

