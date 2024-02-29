class ResponseDetailsController < ApplicationController

  def create
    question_id = params[:question_id]
    answer = params[:answer]
    questionnaire_id = params[:questionnaire_id]
    hardware_id = params[:hardware_id]

    response = Response.find_by(questionnaire_id: questionnaire_id, user_id: current_user.id)

    p "params = #{params}"
    response_detail = response.response_details.find_or_initialize_by(question_id: question_id, hardware_id: hardware_id)

    image_file = params.dig(:response_detail, :image)

    response_detail.image.attach(image_file) if image_file.present?

    image_file.present? ? response_detail.answer = response_detail.image.url : response_detail.answer = answer

    if params[:is_final] == "true"
      response.end_date = Date.today
      response.save
    end

    if response_detail.save
      head :ok
    else
      render json: { errors: response_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
