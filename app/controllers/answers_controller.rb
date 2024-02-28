class ResponsesController < ApplicationController
  def create
    questionnaire_id = params[:questionnaire_id]
    questionnaire = Questionnaire.find(questionnaire_id)
    num_questions = questionnaire.questions.count
    num_answers = params[:answers].values.count { |response| response.present? || response.is_a?(ActionDispatch::Http::UploadedFile) }

    if num_answers == num_questions
      params[:answers].each do |key, response|
        question_id = key.match(/\d+/)[0]
        answer = current_user.answers.new(question_id: question_id, questionnaire_id: questionnaire_id, response: response)
        answer.photo.attach(response) if response.is_a?(ActionDispatch::Http::UploadedFile)
        answer.save
      end
      redirect_to user_profile_path, notice: "Ваши ответы отправлены"
    else
      redirect_back(fallback_location: user_profile_path, alert: "Пожалуйста, ответьте на все вопросы")
    end
  end
end
