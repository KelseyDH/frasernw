class HospitalsController < ApplicationController
  load_and_authorize_resource

  def index
    @hospitals = Hospital.all
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def show
    @hospital = Hospital.find(params[:id])
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def new
    @hospital = Hospital.new
    @hospital.build_location
    @hospital.location.build_address
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def create
    @hospital = Hospital.new(params[:hospital])
    if @hospital.save
      redirect_to @hospital, :notice => "Successfully created #{@hospital.name}."
    else
      render :action => 'new'
    end
  end

  def edit
    @hospital = Hospital.find(params[:id])
    if @hospital.location.blank?
      @hospital.build_location
      @hospital.location.build_address
    elsif @hospital.location.address.blank?
      @hospital.build_address
    end
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def update
    @hospital = Hospital.find(params[:id])
    if @hospital.update_attributes(params[:hospital])
      redirect_to @hospital, :notice  => "Successfully updated #{@hospital.name}."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @hospital = Hospital.find(params[:id])
    name = @hospital.name
    @hospital.destroy
    redirect_to hospitals_url, :notice => "Successfully deleted #{@name}."
  end
end
