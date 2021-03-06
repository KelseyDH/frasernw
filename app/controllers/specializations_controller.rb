class SpecializationsController < ApplicationController
  skip_before_filter :login_required, :only => [:refresh_cache, :refresh_city_cache, :refresh_division_cache]
  load_and_authorize_resource :except => [:refresh_cache, :refresh_city_cache, :refresh_division_cache]
  before_filter :check_token, :only => [:refresh_cache, :refresh_city_cache, :refresh_division_cache]
  skip_authorization_check :only => [:refresh_cache, :refresh_city_cache, :refresh_division_cache]
  
  cache_sweeper :specialization_sweeper, :only => [:create, :update, :destroy]

  def index
    @specializations = Specialization.all
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def show
    @specialization = Specialization.find(params[:id])
    @feedback = FeedbackItem.new
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def new
    @specialization = Specialization.new
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def create
    @specialization = Specialization.new(params[:specialization])
    if @specialization.save
      Division.all.each do |division|
        puts division.name
        so = SpecializationOption.find_or_create_by_specialization_id_and_division_id(@specialization.id, division.id);
        so.owner = User.find_by_id(params[:owner]["#{division.id}"])
        so.content_owner = User.find_by_id(params[:content_owner]["#{division.id}"])
        so.in_progress = params[:in_progress].present? && params[:in_progress]["#{division.id}"].present?
        so.is_new = params[:is_new].present? && params[:is_new]["#{division.id}"].present?
        so.open_to_type = params[:open_to_type]["#{division.id}"]
        so.open_to_sc_category = (params[:open_to_type]["#{division.id}"] == SpecializationOption::OPEN_TO_SC_CATEGORY.to_s) ? ScCategory.find(params[:open_to_sc_category_id]["#{division.id}"]) : nil
        so.show_specialist_categorization_1 = params[:show_specialist_categorization_1].present? && params[:show_specialist_categorization_1]["#{division.id}"].present?
        so.show_specialist_categorization_2 = params[:show_specialist_categorization_2].present? && params[:show_specialist_categorization_2]["#{division.id}"].present?
        so.show_specialist_categorization_3 = params[:show_specialist_categorization_3].present? && params[:show_specialist_categorization_3]["#{division.id}"].present?
        so.show_specialist_categorization_4 = params[:show_specialist_categorization_4].present? && params[:show_specialist_categorization_4]["#{division.id}"].present?
        so.show_specialist_categorization_5 = params[:show_specialist_categorization_5].present? && params[:show_specialist_categorization_5]["#{division.id}"].present?
        so.save
      end
      redirect_to @specialization, :notice => "Successfully created specialty."
    else
      render :action => 'new'
    end
  end

  def edit
    @specialization = Specialization.find(params[:id])
    Division.all.each { |division| SpecializationOption.find_or_create_by_specialization_id_and_division_id(params[:id], division.id) }
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def update
    @specialization = Specialization.find(params[:id])
    SpecializationSweeper.instance.before_controller_update(@specialization)
    if current_user_is_super_admin?
      divisions = Division.all
    else
      divisions = current_user_divisions
    end
    
    if @specialization.update_attributes(params[:specialization])
      divisions.each do |division|
        puts division.name
        so = SpecializationOption.find_by_specialization_id_and_division_id(@specialization.id, division.id);
        so.owner = User.find_by_id(params[:owner]["#{division.id}"])
        so.content_owner = User.find_by_id(params[:content_owner]["#{division.id}"])
        so.in_progress = params[:in_progress].present? && params[:in_progress]["#{division.id}"].present?
        so.is_new = params[:is_new].present? && params[:is_new]["#{division.id}"].present?
        so.open_to_type = params[:open_to_type]["#{division.id}"]
        so.open_to_sc_category = (params[:open_to_type]["#{division.id}"] == SpecializationOption::OPEN_TO_SC_CATEGORY.to_s) ? ScCategory.find(params[:open_to_sc_category]["#{division.id}"]) : nil
        so.show_specialist_categorization_1 = params[:show_specialist_categorization_1].present? && params[:show_specialist_categorization_1]["#{division.id}"].present?
        so.show_specialist_categorization_2 = params[:show_specialist_categorization_2].present? && params[:show_specialist_categorization_2]["#{division.id}"].present?
        so.show_specialist_categorization_3 = params[:show_specialist_categorization_3].present? && params[:show_specialist_categorization_3]["#{division.id}"].present?
        so.show_specialist_categorization_4 = params[:show_specialist_categorization_4].present? && params[:show_specialist_categorization_4]["#{division.id}"].present?
        so.show_specialist_categorization_5 = params[:show_specialist_categorization_5].present? && params[:show_specialist_categorization_5]["#{division.id}"].present?
        so.save
      end
      redirect_to @specialization, :notice  => "Successfully updated specialty."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @specialization = Specialization.find(params[:id])
    SpecializationSweeper.instance.before_controller_destroy(@specialization)
    @specialization.destroy
    redirect_to specializations_url, :notice => "Successfully deleted specialty."
  end
  
  def check_token
    token_required( Specialization, params[:token], params[:id] )
  end
  
  def city
    @specialization = Specialization.find(params[:id])
    @city = City.find(params[:city_id])
    render 'refresh_city.js'
  end
  
  def refresh_cache
    @specialization = Specialization.find(params[:id])
    @feedback = FeedbackItem.new
    render :show, :layout => 'ajax'
  end
  
  def refresh_city_cache
    @specialization = Specialization.find(params[:id])
    @city = City.find(params[:city_id])
    render 'refresh_city.js'
  end
  
  def refresh_division_cache
    @specialization = Specialization.find(params[:id])
    @division = Division.find(params[:division_id])
    render 'refresh_division.js'
  end
end
