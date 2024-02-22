class AnswersController < ApplicationController
  def create
    questionnaire_id = params[:questionnaire_id]
    if params[:answers].present?
      params[:answers].each do |key, response|
        question_id = key.match(/\d+/)[0]
        answer = current_user.answers.new(question_id: question_id, questionnaire_id: questionnaire_id, response: response)
        if response.is_a?(ActionDispatch::Http::UploadedFile)
          answer.photo.attach(response)
        else
          answer.response = response
        end
        answer.save
      end
      redirect_to user_profile_path, notice: "Ваши ответы отправлены"
    end
  end
end
