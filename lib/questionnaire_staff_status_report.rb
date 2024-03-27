require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class QuestionnaireStaffStatusReport < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :breadcrumb_parent do
          nil
        end

        register_instance_option :controller do
          Proc.new do
            @questionnaire = Questionnaire.find_by(id: params[:questionnaire_id])

            if @questionnaire
              if params[:completed] == 'yes'
                @items = Response.includes(:user, :questionnaire)
                                 .where(questionnaire_id: @questionnaire.id, users: {status: true, admin: false})
                                 .where.not(end_date: nil)
              elsif params[:completed] == 'no'
                all_responses = Response.includes(:user)
                                        .where(questionnaire_id: @questionnaire.id, users: {status: true, admin: false})
                not_finished_responses = all_responses.where(end_date: nil)
                user_ids_started_questionnaire = all_responses.pluck(:user_id).uniq
                users_never_started = User.where.not(id: user_ids_started_questionnaire)
                                          .where(status: true, admin: false)

                @items = not_finished_responses + users_never_started
              else
                all_responses = Response.includes(:user)
                                        .where(questionnaire_id: @questionnaire.id, users: {status: true, admin: false})
                users_ids_with_responses = all_responses.pluck(:user_id)
                users_without_responses = User.where.not(id: users_ids_with_responses)
                                              .where(status: true, admin: false)

                @items = all_responses + users_without_responses
              end
            else
              @items = []
            end

            respond_to do |format|
              format.html do
                render action: @action.template_name
              end
              format.xlsx do
                filename = "Отчет по сотрудникам_#{Date.today}.xlsx"
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
                render axlsx: "#{Rails.root}/app/views/rails_admin/main/questionnaire_staff_status_report.xlsx.axlsx", filename: filename, disposition: 'attachment'
              end
            end
          end
        end

        register_instance_option :link_icon do
          'fas fa-file'
        end

        register_instance_option :template_name do
          :questionnaire_staff_status_report
        end
      end
    end
  end
end
