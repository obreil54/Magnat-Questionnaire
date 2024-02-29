class QuestionnairesController < ApplicationController
  def show
    @user_questionnaire_questions = Hardware.joins(category_hard: { questions: :question_type }).where(user: current_user).select('category_hards.name AS category, hardwares.model AS model, hardwares.id AS hardware_id, questions.name AS question, questions.id AS question_id, question_types.name AS question_type, questions.required AS required').distinct
    @questionnaire = Questionnaire.find(params[:id])
    Response.create!(questionnaire: @questionnaire, user: current_user) unless Response.where(questionnaire: @questionnaire, user: current_user).exists?
    @response = Response.find_by(questionnaire: @questionnaire, user: current_user)
  end
end