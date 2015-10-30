# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
#
#   <% if logged_in? %>
#     Welcome <%= current_user.username %>.
#     <%= link_to "Edit profile", edit_current_user_path %> or
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
#
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
#
#   before_filter :login_required, :except => [:index, :show]
module ControllerAuthentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?, :redirect_to_target_or_default
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_user_is_admin?
    return (current_user and current_user.admin?)
  end

  def current_user_is_super_admin?
    return (current_user and current_user.super_admin?)
  end

  def current_user_divisions
    if current_user
      return current_user.divisions
    else
      return []
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def admin_required
    if current_user.nil? || !current_user.admin?
      redirect_to root_url, :alert => "You must be an admin to do that."
    end
  end

  def login_required
    unless logged_in?
      $redis.hincrby("login_required", request.remote_ip, 1) if $redis.connected?
      store_target_location
      redirect_to login_url, :alert => (request.url != root_url) ? "You must log in to access this page." : false
    end
  end

  def not_login_required
    unless !logged_in?
      redirect_to root_url, :alert => "You must be logged out to access this page."
    end
  end

  def token_required(klass, token, id)
    klass_object = klass.find(id)
    unless token == klass_object.token
      redirect_to login_url, :alert => "Invalid token. Please email millerjc@shaw.ca to request or reset your secret url for editing."
    end
  end

  def redirect_to_target_or_default(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  private

  def store_target_location
    session[:return_to] = request.url
  end
end
