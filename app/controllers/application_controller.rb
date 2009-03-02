# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  after_filter :destroy_thread_locals

  hide_action :navigator

  def navigator
    @navigator ||= Navigations::Navigator.new
  end

  private
  def destroy_thread_locals
    ThreadLocals.destroy
  end
end
