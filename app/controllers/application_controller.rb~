# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "default"
  before_filter :require_login

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private

  def require_login
    @user = User.find 1
    @user.reload
  end

  def require_admin
    unless @user.admin?
      flash[:notice] = "You need to have admin permissions to visit that page."
      redirect_to :controller => "village", :action => "index" and return
    end
  end
end
