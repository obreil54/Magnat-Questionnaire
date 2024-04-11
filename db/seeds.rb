# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Hardware.destroy_all
User.destroy_all
CategoryHard.destroy_all
QuestionType.destroy_all
Questionnaire.destroy_all
Question.destroy_all
AnswerVariant.destroy_all
Response.destroy_all
ResponseDetail.destroy_all

user = User.create!(
  email: "obreil54@gmail.com",
  name: "Ilya Obretetskiy",
  status: true,
  code: 123455423452
)

User.create!(
  email: "admin@email.com",
  name: "Admin",
  status: true,
  admin: true,
  code: 123455423457,
  password: "password"
)

laptop_category = CategoryHard.create!(name: "Ноутбук")

CategoryHard.create!(name: "Монитор")
CategoryHard.create!(name: "Планшет")
CategoryHard.create!(name: "Принтер")

laptop = Hardware.create!(
  category_hard: laptop_category,
  model: "MSI Stealth 15M",
  series: "A11UEK-009RU",
  status: true,
  user: user,
  code: 211234235
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
    required: true,
    status: true
)

Question.create!(
  name: "Сделай фото asdasdasf с открытой крышкой",
  category_hard: laptop_category,
  question_type: photo_type,
  required: false,
  status: true
)

select_question = Question.create!(
    name: "Оцени качество работы ноутбука",
    category_hard: laptop_category,
    question_type: select_type,
    required: true,
    status: true
)
Question.create!(
    name: "Напиши детальный комментарий, если есть замечания к ноутбуку",
    category_hard: laptop_category,
    question_type: text_type,
    required: true,
    status: true
)

variant1 = AnswerVariant.create!(
  name: "Удовлетворительно",
)

variant2 = AnswerVariant.create!(
  name: "Hе удовлетворительно",
)

SelectedAnswerVariant.create!(
  question: select_question,
  answer_variant: variant1
)

SelectedAnswerVariant.create!(
  question: select_question,
  answer_variant: variant2
)
