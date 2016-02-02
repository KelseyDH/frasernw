class SubscriptionMailer < ActionMailer::Base
  default from: "noreply@pathwaysbc.ca"

  def resource_update_email(activities_for_subscription, subscription_id)
    @subscription = Subscription.find(subscription_id)
    @user = @subscription.user
    @interval = @subscription.interval_to_words
    @email = @user.email
    @activities = activities_for_subscription
    mail(:to => @subscription.user.email, :from => 'noreply@pathwaysbc.ca', :subject => "Pathways: Your #{@interval} Resource Update")
  end

  def news_update_email(activities_for_subscription, subscription_id)
    @subscription = Subscription.find(subscription_id)
    @user = @subscription.user
    @interval = @subscription.interval_to_words
    @email = @user.email
    @activities = activities_for_subscription

    mail(:to => @subscription.user.email, :from => 'noreply@pathwaysbc.ca', :subject => "Pathways: Your #{@interval} News Update")
  end

  def immediate_resource_update_email(activity_id, user_id)
    @user = User.find_by_id(user_id)
    @activity = SubscriptionActivity.find_by_id(activity_id)
    @interval = Subscription::INTERVAL_HASH[Subscription::INTERVAL_IMMEDIATELY]
    @trackable = @activity.trackable
    @trackable_full_title = @trackable.full_title
    @type_mask_description_formatted = @activity.type_mask_description_formatted
    @update_classification_type = @activity.update_classification_type
    @parent_type = @activity.parent_type
    @division = Division.find_by_id(@activity.owner_id) if @activity.owner_type == "Division"
    @specializations = @activity.trackable.specializations if @activity.trackable.specializations.present?

    mail(
      :to => @user.email,
      :from => 'noreply@pathwaysbc.ca',
      :subject => "Pathways: #{@division} just added #{@type_mask_description_formatted} to #{@parent_type} [#{@update_classification_type.singularize}] "
    )
  end

  def immediate_news_update_email(activity_id, user_id)
    @user = User.find_by_id(user_id)
    @activity = SubscriptionActivity.find_by_id(activity_id)
    @interval = Subscription::INTERVAL_HASH[Subscription::INTERVAL_IMMEDIATELY]
    @trackable = @activity.trackable
    @division = Division.find(@activity.owner_id) if @activity.owner_type == "Division"
    @type_mask_description_formatted = @activity.type_mask_description_formatted
    @update_classification_type = @activity.update_classification_type

    mail(:to => @user.email, :from => 'noreply@pathwaysbc.ca', :subject => "Pathways: #{@type_mask_description_formatted.capitalize} was just added to #{@division} [#{@update_classification_type.singularize}]")

  end


end
