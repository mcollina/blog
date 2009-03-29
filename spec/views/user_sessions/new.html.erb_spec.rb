require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_sessions/new" do
  before(:each) do
    assigns[:user_session] = mock_model(UserSession, :login => "hello world", :password => "", :remember_me => false)
    render 'user_sessions/new'
  end
  
  it "should have an autentication form" do
    response.should have_tag('form')
  end
end
