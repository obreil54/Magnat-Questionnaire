
ActiveRecord::Schema[7.1].define(version: 2024_05_17_140741) do
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answer_variants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_hards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "hardwares", force: :cascade do |t|
    t.string "model"
    t.boolean "status", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "series"
    t.bigint "category_hard_id"
    t.string "code"
    t.index ["category_hard_id"], name: "index_hardwares_on_category_hard_id"
    t.index ["user_id"], name: "index_hardwares_on_user_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "status", default: false, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_hard_id"
    t.bigint "question_type_id"
    t.boolean "required", default: true, null: false
    t.boolean "status", default: true, null: false
    t.index ["category_hard_id"], name: "index_questions_on_category_hard_id"
    t.index ["question_type_id"], name: "index_questions_on_question_type_id"
  end

  create_table "response_details", force: :cascade do |t|
    t.bigint "response_id", null: false
    t.bigint "hardware_id", null: false
    t.bigint "question_id", null: false
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hardware_id"], name: "index_response_details_on_hardware_id"
    t.index ["question_id"], name: "index_response_details_on_question_id"
    t.index ["response_id"], name: "index_response_details_on_response_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "questionnaire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_date"
    t.index ["questionnaire_id"], name: "index_responses_on_questionnaire_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "selected_answer_variants", force: :cascade do |t|
    t.bigint "answer_variant_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_variant_id"], name: "index_selected_answer_variants_on_answer_variant_id"
    t.index ["question_id"], name: "index_selected_answer_variants_on_question_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "settingname", null: false
    t.string "settingvalue"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["settingname"], name: "index_settings_on_settingname", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "log_in_code"
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "name"
    t.string "remember_digest"
    t.string "code"
    t.string "password_digest"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "hardwares", "category_hards"
  add_foreign_key "hardwares", "users"
  add_foreign_key "questions", "category_hards"
  add_foreign_key "questions", "question_types"
  add_foreign_key "response_details", "hardwares"
  add_foreign_key "response_details", "questions"
  add_foreign_key "response_details", "responses"
  add_foreign_key "responses", "questionnaires"
  add_foreign_key "responses", "users"
  add_foreign_key "selected_answer_variants", "answer_variants"
  add_foreign_key "selected_answer_variants", "questions"
end
