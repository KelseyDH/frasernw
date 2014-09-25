class FrontController < ApplicationController
  load_and_authorize_resource
  include ApplicationHelper
  ## kelseynote: FUTURE refactor:
  # before_filter :latest_specialists_and_clinics_updates_variables, only: :index

  def index
    @front = Front.first
    @front = Front.create if @front.blank?
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def as_division
    @division = Division.find(params[:division_id])
    render :action => 'index'
  end
  
  def faq
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def terms_and_conditions
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def edit
    @front = Front.first
    @front = Front.create if @front.blank?
    @division = Division.find(params[:division_id]) if params[:division_id].present?
    if (!current_user_is_super_admin? && !(current_user_divisions.include? @division))
      redirect_to root_url, :notice  => "Not allowed to edit this division."
    end
    @division = @division || current_user_divisions.first
    ScCategory.all.each do |category|
      featured_content = FeaturedContent.in_divisions([@division]).find_all_by_sc_category_id(category.id)
      if category.show_on_front_page?
        #show on front page; make any slots we don't have
        featured_content_count = featured_content.blank? ? 0 : featured_content.length
        for x in (featured_content_count+1)..FeaturedContent::MAX_FEATURED_ITEMS
          FeaturedContent.create( :front => @front, :sc_category => category, :division => @division )
        end
        for x in (FeaturedContent::MAX_FEATURED_ITEMS+1)..featured_content_count
          FeaturedContent.delete(featured_content.first)
        end
      else
        #shouldn't be shown on front page any more
        featured_content.each do |fc|
          FeaturedContent.delete(fc)
        end
      end
    end
    render :layout => 'ajax' if request.headers['X-PJAX']
  end
  
  def update
    @front = Front.first
    division = Division.find(params[:division_id])
    if (!current_user_is_super_admin? && !(current_user_divisions.include? division))
      redirect_to root_url, :notice  => "Not allowed to edit this division."
    elsif @front.update_attributes(params[:front])
      #expire all the featured content for users that are in the divisions that we just updated
      User.in_divisions([division]).map{ |u| u.divisions.map{ |d| d.id } }.uniq.each do |division_group|
        expire_fragment "featured_content_#{division_group.join('_')}"
      end
      
      redirect_to front_as_division_path(division), :notice  => "Successfully updated featured content."
    else
      render :action => 'edit'
    end
  end

  # kelseynote: FUTURE Potential Refactor of Front#Index
  # private

  # def latest_specialists_and_clinics_updates_variables
  #   @user_divisions = current_user_divisions
  #   if current_user_is_admin?
  #     @user_divisions = @division.present? ? [@division] : [@user_divisions.first]
  #     can_edit = current_user_is_super_admin? || (current_user_divisions & @user_divisions).present?
  #     @specializations = current_user_is_admin? ? Specialization.all : Specialization.not_in_progress_for_divisions(@user_divisions).uniq
  #   end
  # end
end