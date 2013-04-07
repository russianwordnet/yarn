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

ActiveRecord::Schema.define(:version => 20130407112728) do

  create_table "current_words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.string   "word",                       :null => false
    t.string   "grammar"
    t.text     "accents"
    t.text     "uris"
    t.datetime "deleted_at"
    t.integer  "revision",    :default => 1
  end

  add_index "current_words", ["approved_at"], :name => "index_current_words_on_approved_at"
  add_index "current_words", ["approver_id"], :name => "index_current_words_on_approver_id"
  add_index "current_words", ["author_id"], :name => "index_current_words_on_author_id"
  add_index "current_words", ["deleted_at"], :name => "index_current_words_on_deleted_at"
  add_index "current_words", ["grammar"], :name => "index_current_words_on_grammar"
  add_index "current_words", ["revision"], :name => "index_current_words_on_revision"
  add_index "current_words", ["word"], :name => "index_current_words_on_word"

  create_table "synsets", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "words"
    t.text     "definitions"
    t.text     "pwns"
    t.datetime "deleted_at"
  end

  add_index "synsets", ["approved_at"], :name => "index_synsets_on_approved_at"
  add_index "synsets", ["approver_id"], :name => "index_synsets_on_approver_id"
  add_index "synsets", ["author_id"], :name => "index_synsets_on_author_id"
  add_index "synsets", ["deleted_at"], :name => "index_synsets_on_deleted_at"
  add_index "synsets", ["revision"], :name => "index_synsets_on_revision"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true

  create_table "words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "created_at",                 :null => false
    t.integer  "revision",    :default => 1, :null => false
    t.string   "word",                       :null => false
    t.string   "grammar"
    t.text     "accents"
    t.text     "uris"
    t.datetime "deleted_at"
    t.integer  "word_id",                    :null => false
  end

  add_index "words", ["approved_at"], :name => "index_entries_on_approved_at"
  add_index "words", ["approver_id"], :name => "index_entries_on_approver_id"
  add_index "words", ["author_id"], :name => "index_entries_on_author_id"
  add_index "words", ["deleted_at"], :name => "index_entries_on_deleted_at"
  add_index "words", ["grammar"], :name => "index_entries_on_grammar"
  add_index "words", ["revision"], :name => "index_entries_on_revision"
  add_index "words", ["word"], :name => "index_words_on_word"
  add_index "words", ["word_id"], :name => "index_words_on_word_id"

  add_foreign_key "current_words", "users", :name => "current_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_words", "users", :name => "current_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synsets", "users", :name => "synsets_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synsets", "users", :name => "synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "words", "current_words", :name => "words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_author_id_fk", :column => "author_id", :dependent => :delete

end
