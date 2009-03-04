class PagesController < ApplicationController
  
  uses_tiny_mce :only => [:new, :edit]

  def self.check_page(controller)
    page = controller.instance_variable_get(:@page)
    not page.nil? and not page.new_record?
  end

  navigator.page do |page|
    page.name = "New Page"
    page.check_path = true
    page.controller = PagesController
    page.link_to_eval = "new_page_path"
  end

  navigator.page do |page|
    page.name = "Edit Page"
    page.link_to_eval = "edit_page_path(@page)"
    page.controller = PagesController
    page.check_path = true
    page.visible_block {|controller| check_page(controller) }
  end

  navigator.page do |page|
    page.name = "Destroy Page"
    page.link_to_eval = "page_path(@page)"
    page.controller = PagesController
    page.check_path = true
    page.visible_block { |controller| check_page(controller) }
    page.link_options = { :confirm => 'Are you sure?', :method => :delete }
    page.current_block { |c| false }
  end

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all, :order => "position")

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
    @pages = Page.find(:all, :order => "position")
    @pages.each do |page|
      page.position = params['pages_list'].index(page.id.to_s) + 1
      page.save
    end
    render :nothing => true
  end

end