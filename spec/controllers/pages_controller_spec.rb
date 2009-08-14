require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs)
  end

  it "should have a page attribute reader" do
    controller.should respond_to(:page)
    controller.page.should be_nil
  end

  it "should hide the page attribute reader" do
    controller.class.hidden_actions.should be_include("page")
  end
  
  describe "responding to GET index with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should expose all pages as @pages" do
      Page.should_receive(:find).with(:all).and_return([mock_page])
      get :index
      assigns[:pages].should == [mock_page]
    end

    describe "with mime type of xml" do
  
      it "should render all pages as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Page.should_receive(:find).with(:all).and_return(pages = mock("Array of Pages"))
        pages.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested page as @page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      get :show, :id => "37"
      assigns[:page].should equal(mock_page)
    end
    
    describe "with mime type of xml" do

      it "should render the requested page as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET index without user logged in" do

    it "should redirect to new_session_url" do
      get :index
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to GET new with user logged in" do
  
    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should expose a new page as @page" do
      Page.should_receive(:new).and_return(mock_page)
      get :new
      assigns[:page].should equal(mock_page)
    end

  end

  describe "responding to GET new without user logged in" do

    it "should redirect to new_session_url" do
      get :new
      response.should redirect_to(new_session_url)
    end
    
  end

  describe "responding to GET edit with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should expose the requested page as @page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      get :edit, :id => "37"
      assigns[:page].should equal(mock_page)
    end

  end

  describe "responding to GET edit without user logged in" do

    it "should redirect to new_session_url" do
      get :edit
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to POST create with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    describe "and with valid params" do
      
      it "should expose a newly created page as @page" do
        Page.should_receive(:new).with({'these' => 'params'}).and_return(mock_page(:save => true))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the created page" do
        Page.stub!(:new).and_return(mock_page(:save => true))
        post :create, :page => {}
        response.should redirect_to(page_url(mock_page))
      end
      
    end
    
    describe "and with invalid params" do

      it "should expose a newly created but unsaved page as @page" do
        Page.stub!(:new).with({'these' => 'params'}).and_return(mock_page(:save => false))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "should re-render the 'new' template" do
        Page.stub!(:new).and_return(mock_page(:save => false))
        post :create, :page => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to POST create without user logged in" do

    it "should redirect to new_session_url" do
      post :create, :page => {}
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to PUT udpate with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    describe "and with valid params" do

      it "should update the requested page" do
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the requested page as @page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(page_url(mock_page))
      end

    end
    
    describe "and with invalid params" do

      it "should update the requested page" do
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the page as @page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should re-render the 'edit' template" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to PUT update without user logged in" do

    it "should redirect to new_session_url" do
      put :update, :id => "42"
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to DELETE destroy with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should destroy the requested page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      mock_page.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the pages list" do
      Page.stub!(:find).and_return(mock_page(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(pages_url)
    end

  end

  describe "responding to DELETE destroy without user logged in" do

    it "should redirect to new_session_url" do
      delete :destroy
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to POST sort with user logged in" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    describe "with valid params" do

      it "should updates all the positions" do
        pages = []

        new_positions = [4,1,3,2]

        (1..4).each do |i|
          page = mock "Page #{i}"
          page.should_receive(:id).any_number_of_times.and_return(i)
          page.should_receive(:position).any_number_of_times.and_return(i)

          if i != new_positions.index(i) + 1
            page.should_receive(:position=).with(new_positions.index(i) + 1)
            page.should_receive(:save).once
          end

          pages << page
        end
        Page.stub!(:find).with(:all).and_return(pages)
        controller.should_receive(:render).with(:nothing => true)

        post :sort, :pages_list => new_positions.map { |i| i.to_s }
      end

    end

    describe "with invalid params" do

      it "should redirect to the pages list" do
        pages = []

        (1..4).each do |i|
          page = mock "Page #{i}"
          page.should_receive(:id).any_number_of_times.and_return(i)
          page.should_receive(:position).any_number_of_times.and_return(i)
          pages << page
        end
        Page.stub!(:find).with(:all).and_return(pages)

        post :sort, :pages_list => []
        response.should redirect_to(pages_url)
      end

    end

  end

  describe "responding to POST sort without user logged in" do

    it "should redirect to new_session_url" do
      post :sort
      response.should redirect_to(new_session_url)
    end

  end
  
end
