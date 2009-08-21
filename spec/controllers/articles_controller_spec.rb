require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do

  def mock_article(stubs={})
    @mock_article ||= mock_model(Article, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose the top five articles as @articles" do
      search = mock "Search"
      Article.should_receive(:descend_by_created_at).and_return(search)
      search.should_receive(:paginate).with({:per_page => 5, :page => nil}).and_return([mock_article])
      get :index
      assigns[:articles].should == [mock_article]
    end

    it "should be able to navigate the articles list" do
      search = mock "Search"
      Article.should_receive(:descend_by_created_at).and_return(search)
      search.should_receive(:paginate).with({:per_page => 5, :page => "2"}).and_return([mock_article])
      get :index, :page => 2
      assigns[:articles].should == [mock_article]
    end

    describe "with mime type of xml" do

      it "should render all articles as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        search = mock "Search"
        Article.should_receive(:descend_by_created_at).and_return(search)
        search.should_receive(:paginate).with({:per_page => 5, :page => nil}).
          and_return(articles = mock("Array of Articles"))
        articles.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end

    end

  end

  describe "responding to GET show" do

    it "should expose the requested article as @article" do
      Article.should_receive(:find).with("37").and_return(mock_article)
      get :show, :id => "37"
      assigns[:article].should equal(mock_article)
    end
    
    describe "with mime type of xml" do

      it "should render the requested article as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Article.should_receive(:find).with("37").and_return(mock_article)
        mock_article.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new with user" do
  
    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should expose a new article as @article" do
      Article.should_receive(:new).and_return(mock_article)
      get :new
      assigns[:article].should equal(mock_article)
    end

  end

  describe "responding to GET new without user" do

    it "should redirect to new_session_url" do
      get :new
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to GET edit with user" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end
  
    it "should expose the requested article as @article" do
      Article.should_receive(:find).with("37").and_return(mock_article)
      get :edit, :id => "37"
      assigns[:article].should equal(mock_article)
    end

  end

  describe "responding to GET edit without user" do

    it "should redirect to new_session_url" do
      get :edit
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to POST create with user" do
    
    before(:each) do
      @user = mock_model(User)
      controller.instance_variable_set(:@current_user, @user)
    end

    describe "with valid params" do
      
      before(:each) do
        mock_article(:save => true)
        mock_article.should_receive(:user=).with(@user)
      end

      it "should expose a newly created article as @article" do
        Article.should_receive(:new).with({'these' => 'params'}).and_return(mock_article)
        post :create, :article => {:these => 'params'}
        assigns(:article).should equal(mock_article)
      end

      it "should redirect to the created article" do
        Article.stub!(:new).and_return(mock_article)
        post :create, :article => {}
        response.should redirect_to(article_url(mock_article))
      end
      
    end
    
    describe "with invalid params" do
      
      before(:each) do
        mock_article(:save => false)
        mock_article.should_receive(:user=).with(@user)
      end

      it "should expose a newly created but unsaved article as @article" do
        Article.stub!(:new).with({'these' => 'params'}).and_return(mock_article)
        post :create, :article => {:these => 'params'}
        assigns(:article).should equal(mock_article)
      end

      it "should re-render the 'new' template" do
        Article.stub!(:new).and_return(mock_article)
        post :create, :article => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to POST create without user" do

    it "should redirect to new_session_url" do
      post :create
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to PUT udpate with user" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    describe "with valid params" do

      it "should update the requested article" do
        Article.should_receive(:find).with("37").and_return(mock_article)
        mock_article.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :article => {:these => 'params'}
      end

      it "should expose the requested article as @article" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => true))
        put :update, :id => "1"
        assigns(:article).should equal(mock_article)
      end

      it "should redirect to the article" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(article_url(mock_article))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested article" do
        Article.should_receive(:find).with("37").and_return(mock_article)
        mock_article.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :article => {:these => 'params'}
      end

      it "should expose the article as @article" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => false))
        put :update, :id => "1"
        assigns(:article).should equal(mock_article)
      end

      it "should re-render the 'edit' template" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to PUT update without user" do

    it "should redirect to new_session_url" do
      put :update
      response.should redirect_to(new_session_url)
    end

  end

  describe "responding to DELETE destroy with user" do

    before(:each) do
      controller.instance_variable_set(:@current_user, mock("User"))
    end

    it "should destroy the requested article" do
      Article.should_receive(:find).with("37").and_return(mock_article)
      mock_article.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the articles list" do
      Article.stub!(:find).and_return(mock_article(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(articles_url)
    end

  end

  describe "responding to DELETE destroy without user" do

    it "should redirect to new_session_url" do
      delete :destroy
      response.should redirect_to(new_session_url)
    end

  end

end
