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

ActiveRecord::Schema[7.0].define(version: 2023_08_27_231555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "md_content"
    t.string "hashnode_id"
    t.string "devto_id"
    t.string "notion_id"
    t.string "medium_id"
    t.string "tags"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashnode_slug"
    t.string "devto_slug"
    t.string "devto_url"
    t.string "hashnode_url"
    t.string "hashnode_cover_image"
    t.string "hashnode_reactions"
    t.string "hashnode_views"
    t.boolean "hashnode_draft"
    t.string "hashnode_reply_count"
    t.string "hashnode_response_count"
    t.string "hashnode_etag"
    t.boolean "devto_draft"
    t.string "devto_comments_count"
    t.string "devto_reactions"
    t.string "devto_views"
    t.string "devto_tags"
    t.string "devto_cover_image"
    t.string "devto_etag"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "github_access_token"
    t.string "notion_access_token"
    t.string "notion_page_id"
    t.string "hashnode_access_token"
    t.string "devto_api_key"
    t.string "hashnode_username"
    t.string "hashnode_blog_handle"
    t.string "name"
    t.string "github_avatar"
    t.string "nickname"
    t.string "github_company"
    t.string "github_location"
    t.string "github_bio"
    t.string "hashnode_publication_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
