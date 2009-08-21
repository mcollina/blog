require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "with user logged in" do
    
    before(:each) do
      controller.instance_variable_set(:@current_user, mock_model(User))
    end
  
    describe "GET index" do

      it "exposes all users as @users" do
        User.should_receive(:find).with(:all).and_return([mock_user])
        get :index
        assigns[:users].should == [mock_user]
      end

      describe "with mime type of xml" do
  
        it "renders all users as xml" do
          User.should_receive(:find).with(:all).and_return(users = mock("Array of Users"))
          users.should_receive(:to_xml).and_return("generated XML")
          get :index, :format => 'xml'
          response.body.should == "generated XML"
        end
    
      end

    end

    describe "GET show" do

      it "exposes the requested user as @user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        get :show, :id => "37"
        assigns[:user].should equal(mock_user)
      end
    
      describe "with mime type of xml" do

        it "renders the requested user as xml" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:to_xml).and_return("generated XML")
          get :show, :id => "37", :format => 'xml'
          response.body.should == "generated XML"
        end

      end
    
    end

    describe "GET new" do
  
      it "exposes a new user as @user" do
        User.should_receive(:new).and_return(mock_user)
        get :new
        assigns[:user].should equal(mock_user)
      end

    end

    describe "GET edit" do
  
      it "exposes the requested user as @user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        get :edit, :id => "37"
        assigns[:user].should equal(mock_user)
      end

    end

    describe "POST create" do

      describe "with valid params" do
      
        it "exposes a newly created user as @user" do
          User.should_receive(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))
          post :create, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end

        it "redirects to the created user" do
          User.stub!(:new).and_return(mock_user(:save => true))
          post :create, :user => {}
          response.should redirect_to(user_url(mock_user))
        end
      
      end
    
      describe "with invalid params" do

        it "exposes a newly created but unsaved user as @user" do
          User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))
          post :create, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end

        it "re-renders the 'new' template" do
          User.stub!(:new).and_return(mock_user(:save => false))
          post :create, :user => {}
          response.should render_template('new')
        end
      
      end
    
    end

    describe "PUT udpate" do

      describe "with valid params" do

        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {:these => 'params'}
        end

        it "exposes the requested user as @user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => true))
          put :update, :id => "1"
          assigns(:user).should equal(mock_user)
        end

        it "redirects to the user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(user_url(mock_user))
        end

      end
    
      describe "with invalid params" do

        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {:these => 'params'}
        end

        it "exposes the user as @user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => false))
          put :update, :id => "1"
          assigns(:user).should equal(mock_user)
        end

        it "re-renders the 'edit' template" do
          User.stub!(:find).and_return(mock_user(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end

      end

    end

    describe "DELETE destroy" do

      it "destroys the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
  
      it "redirects to the users list" do
        User.stub!(:find).and_return(mock_user(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(users_url)
      end

    end

  end


  describe "without user logged in" do

    describe "GET new" do

      it "should redirect to new_session_url" do
        get :new
        response.should redirect_to(new_session_url)
      end

    end

    describe "GET index" do

      it "should redirect to new_session_url" do
        get :index
        response.should redirect_to(new_session_url)
      end

    end

    describe "POST create" do

      it "should redirect to new_session_url" do
        post :create
        response.should redirect_to(new_session_url)
      end

    end

    describe "PUT update" do

      it "should redirect to new_session_url" do
        put :update
        response.should redirect_to(new_session_url)
      end

    end

    describe "DELETE destroy" do

      it "should redirect to new_session_url" do
        delete :destroy
        response.should redirect_to(new_session_url)
      end

    end
  end
end