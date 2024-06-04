class QuestionnairesController < ApplicationController
  def show
    @user_questionnaire_questions = Hardware.joins(category_hard: { questions: :question_type })
                                            .where(user: current_user, status: true)
                                            .where(questions: { status: true })
                                            .select('category_hards.name AS category,
                                                     hardwares.model AS model,
                                                     hardwares.id AS hardware_id,
                                                     hardwares.series AS series,
                                                     hardwares.category_hard_id AS category_hard_id,
                                                     questions.name AS question,
                                                     questions.id AS question_id,
                                                     questions.updated_at AS question_updated_at,
                                                     question_types.name AS question_type,
                                                     questions.required AS required')
                                            .distinct
                                            .order('category_hards.name ASC, hardwares.model ASC, hardwares.series ASC, questions.updated_at ASC')
    @questionnaire = Questionnaire.find(params[:id])
    Response.create!(questionnaire: @questionnaire, user: current_user) unless Response.where(questionnaire: @questionnaire, user: current_user).exists?
    @response = Response.find_by(questionnaire: @questionnaire, user: current_user)
    @response_details = @response&.response_details || []

    @no_questions_assigned = @user_questionnaire_questions.empty?
  end
end
