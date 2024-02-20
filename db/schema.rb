# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_20_120718) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "response"
    t.bigint "question_id", null: false
    t.bigint "user_id", null: false
    t.bigint "questionnaire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["questionnaire_id"], name: "index_answers_on_questionnaire_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "it_equipments", force: :cascade do |t|
    t.string "category"
    t.string "make"
    t.string "model"
    t.text "description"
    t.datetime "loaned_at"
    t.boolean "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_it_equipments_on_user_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "it_equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["it_equipment_id"], name: "index_questionnaires_on_it_equipment_id"
  end

  create_table "questionnaires_questions", id: false, force: :cascade do |t|
    t.bigint "questionnaire_id", null: false
    t.bigint "question_id", null: false
    t.index ["question_id", "questionnaire_id"], name: "idx_on_question_id_questionnaire_id_09b247bfcd"
    t.index ["questionnaire_id", "question_id"], name: "idx_on_questionnaire_id_question_id_ed7ccb1efe"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.string "question_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "code"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questionnaires"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "it_equipments", "users"
  add_foreign_key "questionnaires", "it_equipments"
end
