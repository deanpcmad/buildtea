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

ActiveRecord::Schema[7.1].define(version: 2023_02_07_124729) do
  create_table "builds", force: :cascade do |t|
    t.integer "repo_id", null: false
    t.string "buildkite_id"
    t.string "number"
    t.string "status"
    t.string "commit"
    t.string "branch"
    t.text "message"
    t.string "author_name"
    t.string "author_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repo_id"], name: "index_builds_on_repo_id"
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.string "repo_owner"
    t.string "repo_name"
    t.string "repo_url"
    t.string "description"
    t.integer "gitea_id"
    t.integer "gitea_hook_id"
    t.string "buildkite_id"
    t.string "buildkite_slug"
    t.string "webhook_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "builds", "repos"
end
