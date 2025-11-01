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

ActiveRecord::Schema[8.0].define(version: 2025_11_01_103338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "application_credential_proxy_logs", force: :cascade do |t|
    t.bigint "application_doc_id", null: false
    t.bigint "application_credential_id", null: false
    t.bigint "user_id", null: false
    t.jsonb "request_data"
    t.jsonb "response_data"
    t.datetime "requested_at"
    t.datetime "finished_at"
    t.decimal "credits_used"
    t.integer "duration_ms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_credential_id"], name: "idx_on_application_credential_id_652e413c36"
    t.index ["application_doc_id"], name: "index_application_credential_proxy_logs_on_application_doc_id"
    t.index ["user_id"], name: "index_application_credential_proxy_logs_on_user_id"
  end

  create_table "application_credentials", force: :cascade do |t|
    t.bigint "application_doc_id", null: false
    t.string "title"
    t.text "description"
    t.string "credential_type"
    t.jsonb "rate_limits"
    t.jsonb "settings"
    t.jsonb "auth_data"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_doc_id"], name: "index_application_credentials_on_application_doc_id"
  end

  create_table "application_doc_requests", force: :cascade do |t|
    t.bigint "application_doc_id", null: false
    t.string "title"
    t.text "description"
    t.text "curl_template"
    t.jsonb "swagger_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_doc_id"], name: "index_application_doc_requests_on_application_doc_id"
  end

  create_table "application_docs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "base_url"
    t.jsonb "tags", default: []
    t.boolean "is_active"
    t.jsonb "docs"
    t.jsonb "auth_fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "db_scrappers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.string "url"
    t.jsonb "meta_data"
    t.string "source_provider"
    t.string "sub_type"
    t.jsonb "response"
    t.jsonb "fildered_response"
    t.text "parser_code"
    t.string "final_response"
    t.text "knowledge_storage_cypher_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_db_scrappers_on_project_id"
    t.index ["user_id"], name: "index_db_scrappers_on_user_id"
  end

  create_table "knowledge_queryfiers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id", null: false
    t.text "cypher_dynamic_query"
    t.jsonb "meta_data_swagger_docs"
    t.string "tags"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_knowledge_queryfiers_on_project_id"
    t.index ["user_id"], name: "index_knowledge_queryfiers_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_credits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total_credits"
    t.decimal "used_credits"
    t.decimal "current_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_credits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_views_on_email", unique: true
    t.index ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true
  end

  add_foreign_key "application_credential_proxy_logs", "application_credentials"
  add_foreign_key "application_credential_proxy_logs", "application_docs"
  add_foreign_key "application_credential_proxy_logs", "users"
  add_foreign_key "application_credentials", "application_docs"
  add_foreign_key "application_doc_requests", "application_docs"
  add_foreign_key "db_scrappers", "projects"
  add_foreign_key "db_scrappers", "users"
  add_foreign_key "knowledge_queryfiers", "projects"
  add_foreign_key "knowledge_queryfiers", "users"
  add_foreign_key "user_credits", "users"
end
