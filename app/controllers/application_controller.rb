# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  ensure_authenticated_to_facebook
  before_filter :require_login

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private

  def require_login
    @fbuser = session[:facebook_session].user
    @user = User.first_where :facebook_id => @fbuser.facebook_id
    if @user.nil?
      @user = User.create_from @fbuser 
    else
      @user.reload
    end
  end

  def require_admin
    unless @user.admin?
      flash[:notice] = "You need to have admin permissions to visit that page."
      redirect_to :controller => "village", :action => "index" and return
    end
  end
end
