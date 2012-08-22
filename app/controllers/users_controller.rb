class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :login_required, :only => [:validate, :signup, :setup]

  def index
    @users = User.find(:all)
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def new
    @user = User.new
    @user.user_controls_specialists.build
    @user.user_controls_clinics.build
    @new_user = true
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def create
    @user = User.new(params[:user])
    if @user.save :validate => false #so we can avoid setting up with emails or passwords
      redirect_to users_path, :notice => "User #{@user.name} successfully created."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @user.user_controls_specialists.build
    @user.user_controls_clinics.build
    @new_user = false
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def show
    @user = User.find(params[:id])
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if @user.save :validate => false #so we can edit a pending account
      redirect_to users_url, :notice  => "Successfully updated user."
    else
      @new_user = false
      render :action => 'edit'
    end
  end
  
  def validate
    if params.blank? || params[:user].blank?
      redirect_to login_url
    else
      @user = User.find_by_saved_token(params[:user][:saved_token].downcase)
      if @user.blank?
        redirect_to login_url, :alert  => "Sorry, your access key was not recognized."
      elsif @user.email.present?
        redirect_to login_url, :alert  => "Sorry, your access key has already been used to set up an account."
      else
        render :action => 'signup', :layout => 'user_sessions'
      end
    end
  end
  
  def setup
    if params.blank? || params[:user].blank?
      redirect_to login_url
    else
      @user = User.find_by_saved_token(params[:user][:saved_token].downcase)
      if @user.present?
        if @user.update_attributes(params[:user])
          redirect_to login_url, :notice  => "Your account has been set up; please log in using #{@user.email} and your newly created password. Welcome to Pathways!"
        else
          render :action => 'signup'
        end
      else
        redirect_to login_url, :alert  => "Sorry, your access key was not recognized."
      end
    end
  end
  
  def change_name
    @user = current_user
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def update_name
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :layout => 'ajax', :notice => "Your name was successfully changed to #{@user.name}."
    else
      render :action => :change_name, :layout => 'user_sessions'
    end
  end
  
  def change_email
    @user = current_user
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def update_email
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to login_url, :layout => 'user_sessions', :notice => "Your e-mail address was successfully changed to #{@user.email}, please log in again with your new e-mail address."
    else
      render :action => :change_email, :layout => 'user_sessions'
    end
  end
  
  def change_password
    @user = current_user
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def update_password
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to login_url, :layout => 'user_sessions', :notice => "Your password was successfully changed, please log in again with your new password."
    else
      render :action => :change_password, :layout => 'user_sessions'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, :notice => "Successfully deleted user."
  end
  
end
