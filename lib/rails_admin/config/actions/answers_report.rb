require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class AnswersReport < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :breadcrumb_parent do
          nil
        end

        register_instance_option :controller do
          Proc.new do
            @response_details = []

            if params[:questionnaire_id].present?
              @response_details = ResponseDetail.includes(response: [:user, :questionnaire], question: [:category_hard], hardware: [])
              .where(responses: { questionnaire_id: params[:questionnaire_id] })
              .joins(response: :user)
              .where(users: { status: true, admin: false })
              .order('response_details.created_at DESC')
              .distinct

              if params[:category_hard_id].present?
                @response_details = @response_details.joins(question: :category_hard)
                .where(category_hards: { id: params[:category_hard_id] })
                .distinct
              end

              if params[:user_id].present?
                @response_details = @response_details.where(responses: { user_id: params[:user_id] })
              end
            end

            respond_to do |format|
              format.html do
                render action: @action.template_name
              end
              format.xlsx do
                filename = "Отчет по ответам_#{Date.today}.xlsx"
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
                render axlsx: "#{Rails.root}/app/views/rails_admin/main/answers_report.xlsx.axlsx", filename: filename, disposition: 'attachment'
              end
            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-file'
        end

        register_instance_option :template_name do
          :answers_report
        end
      end
    end
  end
end
