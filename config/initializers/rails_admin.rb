require Rails.root.join('lib',  'questionnaire_staff_status_report.rb')
require Rails.root.join('lib',  'answers_report.rb')

RailsAdmin.config do |config|

  config.asset_source = :sprockets

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  config.authenticate_with do
    unless current_user && current_user.admin?
      redirect_to main_app.root_path, alert: "У вас нет доступа администратора"
    end
  end

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

    questionnaire_staff_status_report
    answers_report

    all
    import
  end

  config.model 'User' do
    edit do
      exclude_fields :log_in_code, :remember_digest, :responses, :hardwares
    end

    create do
      exclude_fields :log_in_code, :rememeber_digest, :responses, :hardwares
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

  config.configure_with(:import) do |config|
    config.update_if_exists = true
    config.rollback_on_error = true
  end

  config.model 'User' do
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at, :log_in_code, :remember_digest, :admin, :hardwares, :responses
      mapping_key :code
      mapping_key_list [:code]
    end
  end

  config.model 'Hardware' do
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at, :response_details
      mapping_key :code
      mapping_key_list [:code]
    end
  end
end
