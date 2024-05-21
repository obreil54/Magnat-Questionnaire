class ResponseDetailsController < ApplicationController
  before_action :check_image_question_and_validate_settings, only: [:create]

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
      relative_path = PhotoPathGenerator.generate_path(current_user, response_detail.hardware, response.created_at)
      file_name = PhotoPathGenerator.generate_filename(response_detail.hardware.series, response.created_at)
      full_relative_path = "#{relative_path}#{file_name}"

      response_detail.image.attach(io: image_file, filename: file_name)
      response_detail.answer = full_relative_path
    elsif keep_existing_image && response_detail.image.attached?
      response_detail.answer = response_detail.image.url unless response_detail.answer.present?
    else
      response_detail.answer = answer if answer.present? && !image_file.present?
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

  private

  def check_image_question_and_validate_settings
    question = Question.find(params[:question_id])

    if question.question_type.name == "Фото"
       validate_settings
    end
  end

  def validate_settings
    missing_settings = []

    missing_settings << "fileapi_path" unless Setting.fileapi_path.present?
    missing_settings << "fileapi_url" unless Setting.fileapi_url.present?
    missing_settings << "fileapi_token" unless Setting.fileapi_token.present?

    unless missing_settings.empty?
      message = "Внимание, не указана настройка #{missing_settings.join(', ')}, обратитесь к администратору!"
      logger.error(message)
      render json: { error: message }, status: :unprocessable_entity
    end
  end
end
