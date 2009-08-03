require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/sessions/new" do
  before(:each) do
    assigns[:user_session] = mock_model(UserSession, :login => "hello world", :password => "", :remember_me => false)
    render 'sessions/new'
  end
  
  it "should have an autentication form" do
    response.should have_tag('form')
  end

  it "should assign the correct title" do
    assigns[:title].should == "Login"
  end
end
