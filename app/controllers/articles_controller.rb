class ArticlesController < ApplicationController
  
  uses_tiny_mce :only => [:new, :edit]

  navigator.page do |page|
    page.name = "New Article"
    page.check_path = true
    page.controller = ArticlesController
    page.link_to_eval = "new_article_path"
  end

  navigator.page do |page|
    page.name = "Edit Article"
    page.link_to_eval = "edit_article_path(@article)"
    page.controller = ArticlesController
    page.check_path = true
    page.visible_block do |controller|
      controller.instance_variable_get(:@article)
    end
  end

  navigator.page do |page|
    page.name = "Destroy Article"
    page.link_to_eval = "article_path(@article)"
    page.controller = ArticlesController
    page.check_path = true
    page.visible_block do |controller|
      controller.instance_variable_get(:@article)
    end
    page.link_options = { :confirm => 'Are you sure?', :method => :delete }
    page.current_block { |c| false }
  end


  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
