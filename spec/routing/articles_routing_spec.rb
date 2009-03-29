require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "articles", :action => "index").should == "/articles"
    end
  
    it "should map #new" do
      route_for(:controller => "articles", :action => "new").should == "/articles/new"
    end
  
    it "should map #show" do
      route_for(:controller => "articles", :action => "show", :id => "1").should == "/articles/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "articles", :action => "edit", :id => "1").should == "/articles/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "articles", :action => "update", :id => "1").should == {:path => "/articles/1", :method => :put}
    end
  
    it "should map #destroy" do
      route_for(:controller => "articles", :action => "destroy", :id => "1").should == {:path => "/articles/1", :method => :delete}
    end

    it "should map #create" do
      route_for(:controller => "articles", :action => "create").should == {:path => "/articles", :method => :post}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/articles").should == {:controller => "articles", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/articles/new").should == {:controller => "articles", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/articles").should == {:controller => "articles", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/articles/1").should == {:controller => "articles", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/articles/1/edit").should == {:controller => "articles", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/articles/1").should == {:controller => "articles", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/articles/1").should == {:controller => "articles", :action => "destroy", :id => "1"}
    end
  end
end
