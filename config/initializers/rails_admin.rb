require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/config/actions/answers_report'
require 'rails_admin/config/actions/questionnaire_staff_status_report'

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
      exclude_fields :log_in_code, :remember_digest, :responses, :hardwares, :password_digest
      field :password do
        css_class do
          bindings[:object].admin? ? nil : 'd-none'
        end
        help 'Пароль должен содержать не менее 6 символов'
      end
    end

    create do
      exclude_fields :log_in_code, :rememeber_digest, :responses, :hardwares, :password_digest
      field :password do
        css_class 'd-none'
        help 'Пароль должен содержать не менее 6 символов'
      end
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
      exclude_fields :id, :created_at, :updated_at, :log_in_code, :remember_digest, :admin, :hardwares, :responses, :password_digest
      mapping_key :code
      mapping_key_list [:code]
      field :email do
        label do
          'email'
        end
      end
      field :status do
        label do
          'status'
        end
      end
      field :name do
        label do
          'name'
        end
      end
      field :code do
        label do
          'code'
        end
      end
    end
  end

  config.model 'Hardware' do
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at, :response_details
      mapping_key :code
      mapping_key_list [:code]
      field :model do
        label do
          'model'
        end
      end
      field :status do
        label do
          'status'
        end
      end
      field :series do
        label do
          'series'
        end
      end
      field :code do
        label do
          'status'
        end
      end
      field :user do
        label do
          'user'
        end
      end
      field :category_hard do
        label do
          'category_hard'
        end
      end
    end
  end
end
