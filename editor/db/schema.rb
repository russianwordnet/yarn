# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130310234237) do

  create_table "entries", :force => true do |t|
    t.string   "type",        :null => false
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "entries", ["approver_id"], :name => "index_entries_on_approver_id"
  add_index "entries", ["author_id"], :name => "index_entries_on_author_id"
  add_index "entries", ["type"], :name => "index_entries_on_type"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true

  add_foreign_key "entries", "users", :name => "entries_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "entries", "users", :name => "entries_author_id_fk", :column => "author_id", :dependent => :delete

end
