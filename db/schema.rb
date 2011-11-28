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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110517043331) do

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.boolean  "completed",      :default => false
    t.integer  "position"
    t.integer  "created_by_id"
    t.integer  "assigned_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["assigned_to_id"], :name => "index_tasks_on_assigned_to_id"
  add_index "tasks", ["created_by_id"], :name => "index_tasks_on_created_by_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
