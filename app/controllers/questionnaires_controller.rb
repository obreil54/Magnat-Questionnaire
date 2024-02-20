class QuestionnairesController < ApplicationController
  def show
    @questionnaire = Questionnaire.find(params[:id])
    @questions = @questionnaire.questions.order(:id)
  end
end
