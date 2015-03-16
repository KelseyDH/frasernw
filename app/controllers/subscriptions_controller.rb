class SubscriptionsController < ApplicationController
 load_and_authorize_resource
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = current_user.subscriptions.includes(:specializations, :divisions, :sc_categories).all
    render :layout => 'ajax' if request.headers['X-PJAX']

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @subscriptions }
    # end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = current_user.subscriptions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
    @subscription = current_user.subscriptions.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = current_user.subscriptions.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.user = current_user
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully created.' }
        format.json { render json: @subscription, status: :created, location: @subscription }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = current_user.subscriptions.find(params[:id])
    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to subscriptions_url, notice: "Subscription was successfully updated." }
        format.json { head :ok }
      else
        format.html { render action: "edit", notice: "Sorry, there was an error updating your subscription." }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    if @subscription.user == current_user && @subscription.destroy
      respond_to do |format|
        format.html { redirect_to subscriptions_url }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to @subscription, alert: "We had trouble deleting this subscription"}
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # add custom param parsing here
  def subscription_params
    params[:subscription]
  end
end
