class ResponsesController < ApplicationController
  def update
    response = Response.find(params[:id])
    response.end_date = DateTime.now

    if response.save
      redirect_to success_path
    else
      redirect_to questionnaire_path(response.questionnaire), alert: 'Произошла ошибка при завершении анкеты. Пожалуйста, попробуйте еще раз.'
    end
  end
end
