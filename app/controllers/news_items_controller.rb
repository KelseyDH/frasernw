class NewsItemsController < ApplicationController
  load_and_authorize_resource
  skip_authorization_check only: [:update_borrowing]
  skip_authorize_resource only: [:update_borrowing]

  def index
    @division = begin
      if params[:division_id].present?
        Division.find(params[:division_id])
      else
        current_user.divisions.first
      end
    end

    @props = {
      app: {
        currentUser: {
          isSuperAdmin: current_user.super_admin?,
          divisionIds: current_user.divisions.map(&:id)
        },
        divisions: Division.all.inject({}) do |memo, division|
          memo.merge(division.id => {
            name: division.name
          })
        end,
        newsItems: Serialized.generate(:news_items)
      },
      ui: {
        divisionId: @division.id
      }
    }

    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def show
    @news_item = NewsItem.find(params[:id])
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def new
    @news_item = NewsItem.new
    @divisions = NewsItem.permitted_division_assignments(current_user)
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def create
    @news_item = NewsItem.new(params[:news_item])
    if @news_item.save && @news_item.display_in_divisions!(divisions_to_assign(params, @news_item), current_user)
      create_news_item_activity

      redirect_to front_as_division_path(@news_item.owner_division),
        :notice  => "Successfully created news item.  Please allow a couple minutes for the front page to show your changes."
    else
      render :edit
    end
  end

  def edit
    @news_item = NewsItem.find(params[:id])
    @divisions = NewsItem.permitted_division_assignments(current_user)
    render :layout => 'ajax' if request.headers['X-PJAX']
  end

  def update
    @news_item = NewsItem.find(params[:id])

    if current_user.divisions.include?(@news_item.owner_division)
      render(action: :edit) unless @news_item.update_attributes(params[:news_item])
    end

    if @news_item.display_in_divisions!(divisions_to_assign(params, @news_item), current_user)
      redirect_to front_as_division_path(current_user.divisions.first),
        :notice  => "Successfully updated news item. Please allow a couple minutes for the front page to show your changes."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @news_item = NewsItem.find(params[:id])
    @news_item.destroy
    redirect_to news_items_path, :notice => "Successfully deleted news item."
  end

  def update_borrowing
    @news_item = NewsItem.find(params[:id])
    @division = Division.find(params[:division_id])

    if params[:borrow] == "false" && @news_item.user_can_unborrow?(current_user, @division)
      @news_item.unborrow_from(@division)

      redirect_to news_item_path(@news_item),
        notice: "Successfully stopped borrowing news item for #{@division.name}."
    else
      redirect_to news_item_path(@news_item),
        notice: "Unauthorized"
    end
  end

  private

  def divisions_to_assign(params, news_item)
    if params[:news_item][:division_ids]
      params[:news_item][:division_ids].select(&:present?).map do |id|
        Division.find(id)
      end
    else
      [ news_item.owner_division ]
    end
  end

  def create_news_item_activity
    # TODO: #division
    @news_item.create_activity(
      action: :create,
      update_classification_type: Subscription.news_update,
      type_mask: @news_item.type_mask,
      type_mask_description: @news_item.type,
      format_type: 0,
      format_type_description: "Internal",
      parent_id: @news_item.owner_division.id,
      parent_type: "Division",
      owner: @news_item.owner_division
    )
  end
end
