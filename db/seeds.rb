# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
ItEquipment.destroy_all
Questionnaire.destroy_all
EquipmentQuestionnaire.destroy_all
Question.destroy_all

user = User.create!(
  email: "obreil54@gmail.com",
  first_name: "Ilya",
  last_name: "Obretetskiy",
  status: true
)

User.create!(
  email: "admin@email.com",
  first_name: "Admin",
  last_name: "Admin",
  status: true,
  admin: true
)

laptop = ItEquipment.create!(
  category: "laptop",
  make: "MSI",
  model: "Stealth 15M",
  description: "Some minor damage and battery only functions when plugged in",
  loaned_at: DateTime.now,
  status: true,
  user: user
)

questionnaire = Questionnaire.create!(
  title: "Bi-Annual check of your #{laptop.make} #{laptop.model} #{laptop.category}",
  description: "Please fill out this questionnaire to ensure that your laptop is in good condition",
)

EquipmentQuestionnaire.create!(
  it_equipment: laptop,
  questionnaire: questionnaire
)

questionnaire.questions.create!([
  {
    content: "Please describe any issues you are having with the equipment",
    question_type: "text"
  },
  {
    content: "Please rate the condition of your device?",
    question_type: "select",
    options: ["Great", "Good", "OK", "Poor", "Not Working"]
  },
  {
    content: "Please take a photo of the screen",
    question_type: "photo"
  }
])
