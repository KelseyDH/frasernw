# Modify forms based on the type of interaction and current user

# @is_review == secret edit or automated_edit

class FormModifier
  INTERACTION_TYPES = [
    :new,
    :edit,
    :review,
    :rereview,
    :review
  ]

  attr_reader :interaction_type, :current_user, :options

  # Defined in controller
  def initialize(interaction_type, user_type, options = {})
    if !INTERACTION_TYPES.include? interaction_type
      raise "invalid interaction type"
    end

    @interaction_type = interaction_type
    @current_user     = current_user
    @options          = options
  end

  def secret_edit?
    token_edit? && !bot_edit?
  end

  def bot_edit?
    token_edit? && options[:bot] == true
  end

  def token_edit?
    current_user.nil? && interaction_type == :edit
  end

  def admin_rereview?
    current_user.present? && current_user.admin? && interaction_type == :rereview
  end

  def new_record?
    interaction_type == :new
  end
end
