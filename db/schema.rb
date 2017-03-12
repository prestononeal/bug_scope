# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170311070723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.string   "name"
    t.string   "branch"
    t.string   "product"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instances", force: :cascade do |t|
    t.integer  "issue_id"
    t.integer  "build_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "found_at"
    t.index ["build_id"], name: "index_instances_on_build_id", using: :btree
    t.index ["issue_id"], name: "index_instances_on_issue_id", using: :btree
  end

  create_table "issues", force: :cascade do |t|
    t.string   "issue_type"
    t.text     "signature"
    t.string   "ticket"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "state"
    t.text     "note"
    t.integer  "parent_id"
    t.index ["parent_id"], name: "index_issues_on_parent_id", using: :btree
  end

  add_foreign_key "instances", "builds"
  add_foreign_key "instances", "issues"
  add_foreign_key "issues", "issues", column: "parent_id"
end
