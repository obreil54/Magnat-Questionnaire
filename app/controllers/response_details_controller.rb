class ResponseDetailsController < ApplicationController

  def create
    question_id = params[:question_id]
    answer = params[:answer]
    questionnaire_id = params[:questionnaire_id]
    hardware_id = params[:hardware_id]
    keep_existing_image = params[:keep_existing_image] == "true"

    response = Response.find_by(questionnaire_id: questionnaire_id, user_id: current_user.id)
    response_detail = response.response_details.find_or_initialize_by(question_id: question_id, hardware_id: hardware_id)

    image_file = params.dig("response_details_attributes", question_id.to_s, "image")
    if image_file.present?
      response_detail.image.attach(image_file)
      response_detail.answer = response_detail.image.url
    elsif keep_existing_image && response_detail.image.attached?
      response_detail.answer = response_detail.image.url unless response_detail.answer.present?
    else
      if answer.present? && !image_file.present?
        response_detail.answer = answer
      end
    end


    if params[:is_final] == "true"
      response.end_date = DateTime.now
      response.save
    end

    if response_detail.save
      head :ok
    else
      render json: { errors: response_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
