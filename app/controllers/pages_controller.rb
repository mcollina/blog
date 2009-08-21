class PagesController < ApplicationController
  
  uses_tiny_mce :only => [:new, :edit]

  before_filter :require_user, :except => :show

  check_model :page

  navigator.page do |page|
    page.name = "New Page"
    page.link_to_eval = "new_page_path"
  end

  navigator.page do |page|
    page.name = "Show Page"
    page.link_to_eval = "page_path(@page)"
    page.visible_block do |controller|
      controller.page? and not page.current? controller
    end
  end

  navigator.page do |page|
    page.name = "Edit Page"
    page.link_to_eval = "edit_page_path(@page)"
    page.visible_block do |controller|
      controller.page? and not page.current? controller
    end
  end

  navigator.page do |page|
    page.name = "Destroy Page"
    page.link_to_eval = "page_path(@page)"
    page.visible_method = :page?
    page.link_options = { :confirm => 'Are you sure?', :method => :delete }
  end

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  def sort
    @pages = Page.find(:all)

    begin
      @pages.each do |page|
        new_position = params[:pages_list].index(page.id.to_s) + 1

        if new_position != page.position
          page.position = new_position
          page.save
        end
      end
      render :nothing => true
    rescue
      redirect_to pages_path
    end
  end

  hide_action(:page)

  def page
    @page
  end
end
