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
Hardware.destroy_all
CategoryHard.destroy_all
QuestionType.destroy_all
Questionnaire.destroy_all
Question.destroy_all

user = User.create!(
  email: "obreil54@gmail.com",
  name: "Ilya Obretetskiy",
  status: true
)

User.create!(
  email: "admin@email.com",
  name: "Admin",
  status: true,
  admin: true
)

laptop_category = CategoryHard.create!(name: "Ноутбук")

CategoryHard.create!(name: "Монитор")
CategoryHard.create!(name: "Планшет")
CategoryHard.create!(name: "Принтер")

laptop = Hardware.create!(
  category_hard: laptop_category,
  model: "MSI Stealth 15M",
  series: "A11UEK-009RU",
  loaned_at: DateTime.now,
  status: true,
  user: user
)

text_type = QuestionType.create!(name: "Произвольный Ответ")
select_type = QuestionType.create!(name: "Выбор Значений")
photo_type = QuestionType.create!(name: "Фото")


questionnaire = Questionnaire.create!(
  name: "Опрос состояния техники весна 2024",
  start_date: Date.today,
  end_date: Date.today + 1.month,
)

Question.create!(
    name: "Сделай фото ноутбука с открытой крышкой",
    category_hard: laptop_category,
    question_type: photo_type,
    required: true
)
select_question = Question.create!(
    name: "Оцени качество работы ноутбука",
    category_hard: laptop_category,
    question_type: select_type,
    required: true
)
Question.create!(
    name: "Напиши детальный комментарий, если есть замечания к ноутбуку",
    category_hard: laptop_category,
    question_type: text_type,
    required: true
)

AnswerVariant.create!(
  name: "Удовлетворительно",
  question: select_question
)

AnswerVariant.create!(
  name: "Hе удовлетворительно",
  question: select_question
)
