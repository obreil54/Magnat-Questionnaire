class AnswersController < ApplicationController
  def create
    params[:answers].each do |question_id, response|
      current_user.answers.create(question_id: question_id, response: response)
    end
    redirect_to user_profile_path, notice: "Your answers have been submitted"
  end
end
