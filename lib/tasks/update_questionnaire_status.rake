namespace :questionnaire do
  desc "Update questionnaire status based on current date"
  task update_status: :environment do
    puts "Updating questionnaire statuses..."
    Questionnaire.find_each do |questionnaire|
      active_status = questionnaire.start_date.present? && questionnaire.end_date.present? && (questionnaire.start_date <= Date.today) && (Date.today <= questionnaire.end_date)
      questionnaire.update!(status: active_status)
    end
    puts "Statuses updated."
  end
end
