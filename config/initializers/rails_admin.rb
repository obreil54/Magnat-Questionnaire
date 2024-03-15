RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = false
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  config.authenticate_with do
    unless current_user && current_user.admin?
      redirect_to main_app.root_path, alert: "У вас нет доступа администратора"
    end
  end

  config.asset_source = :sprockets

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    edit do
      exclude_fields :code, :remember_digest, :responses
    end

    create do
      exclude_fields :code, :rememeber_digest, :responses
    end
  end

  config.model 'Hardware' do
    edit do
      exclude_fields :response_details
    end

    create do
      exclude_fields :response_details
    end
  end

  config.model 'Question' do
    edit do
      exclude_fields :response_details, :selected_answer_variants
    end

    create do
      exclude_fields :response_details, :selected_answer_variants
    end
  end

  config.model 'Questionnaire' do
    edit do
      exclude_fields :responses, :status
    end

    create do
      exclude_fields :responses, :status
    end
  end

  config.model 'AnswerVariant' do
    edit do
      exclude_fields :selected_answer_variants, :questions
    end

    create do
      exclude_fields :selected_answer_variants, :questions
    end
  end
end
