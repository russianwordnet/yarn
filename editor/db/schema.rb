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

ActiveRecord::Schema.define(:version => 20130705092512) do

  create_table "current_definitions", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "text",                       :null => false
    t.string   "source"
    t.string   "uri"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_definitions", ["approved_at"], :name => "index_current_definitions_on_approved_at"
  add_index "current_definitions", ["approver_id"], :name => "index_current_definitions_on_approver_id"
  add_index "current_definitions", ["author_id"], :name => "index_current_definitions_on_author_id"
  add_index "current_definitions", ["deleted_at"], :name => "index_current_definitions_on_deleted_at"
  add_index "current_definitions", ["revision"], :name => "index_current_definitions_on_revision"
  add_index "current_definitions", ["source"], :name => "index_current_definitions_on_source"
  add_index "current_definitions", ["updated_at"], :name => "index_current_definitions_on_updated_at"
  add_index "current_definitions", ["uri"], :name => "index_current_definitions_on_uri"

  create_table "current_samples", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "text",                       :null => false
    t.string   "source"
    t.string   "uri"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_samples", ["approved_at"], :name => "index_current_samples_on_approved_at"
  add_index "current_samples", ["approver_id"], :name => "index_current_samples_on_approver_id"
  add_index "current_samples", ["author_id"], :name => "index_current_samples_on_author_id"
  add_index "current_samples", ["deleted_at"], :name => "index_current_samples_on_deleted_at"
  add_index "current_samples", ["revision"], :name => "index_current_samples_on_revision"
  add_index "current_samples", ["source"], :name => "index_current_samples_on_source"
  add_index "current_samples", ["updated_at"], :name => "index_current_samples_on_updated_at"
  add_index "current_samples", ["uri"], :name => "index_current_samples_on_uri"

  create_table "current_synset_words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1,  :null => false
    t.integer  "word_id",                     :null => false
    t.boolean  "nsg"
    t.string   "marks",       :default => [],                 :array => true
    t.integer  "samples_ids", :default => [],                 :array => true
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_synset_words", ["approved_at"], :name => "index_current_synset_words_on_approved_at"
  add_index "current_synset_words", ["approver_id"], :name => "index_current_synset_words_on_approver_id"
  add_index "current_synset_words", ["author_id"], :name => "index_current_synset_words_on_author_id"
  add_index "current_synset_words", ["deleted_at"], :name => "index_current_synset_words_on_deleted_at"
  add_index "current_synset_words", ["marks"], :name => "index_current_synset_words_on_marks"
  add_index "current_synset_words", ["nsg"], :name => "index_current_synset_words_on_nsg"
  add_index "current_synset_words", ["revision"], :name => "index_current_synset_words_on_revision"
  add_index "current_synset_words", ["updated_at"], :name => "index_current_synset_words_on_updated_at"
  add_index "current_synset_words", ["word_id"], :name => "index_current_synset_words_on_word_id"

  create_table "current_synsets", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",        :default => 1,  :null => false
    t.datetime "deleted_at"
    t.datetime "updated_at"
    t.integer  "words_ids",       :default => [],                 :array => true
    t.integer  "definitions_ids", :default => [],                 :array => true
  end

  add_index "current_synsets", ["approved_at"], :name => "index_current_synsets_on_approved_at"
  add_index "current_synsets", ["approver_id"], :name => "index_current_synsets_on_approver_id"
  add_index "current_synsets", ["author_id"], :name => "index_current_synsets_on_author_id"
  add_index "current_synsets", ["definitions_ids"], :name => "index_current_synsets_on_definitions_ids"
  add_index "current_synsets", ["deleted_at"], :name => "index_current_synsets_on_deleted_at"
  add_index "current_synsets", ["revision"], :name => "index_current_synsets_on_revision"
  add_index "current_synsets", ["words_ids"], :name => "index_current_synsets_on_words_ids"

  create_table "current_words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.string   "word",                        :null => false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "revision",    :default => 1
    t.integer  "accents",     :default => [],                 :array => true
    t.string   "uris",        :default => [],                 :array => true
    t.integer  "frequency",   :default => 0,  :null => false
  end

  add_index "current_words", ["accents"], :name => "index_current_words_on_accents"
  add_index "current_words", ["approved_at"], :name => "index_current_words_on_approved_at"
  add_index "current_words", ["approver_id"], :name => "index_current_words_on_approver_id"
  add_index "current_words", ["author_id"], :name => "index_current_words_on_author_id"
  add_index "current_words", ["deleted_at"], :name => "index_current_words_on_deleted_at"
  add_index "current_words", ["frequency"], :name => "index_current_words_on_frequency"
  add_index "current_words", ["grammar"], :name => "index_current_words_on_grammar"
  add_index "current_words", ["revision"], :name => "index_current_words_on_revision"
  add_index "current_words", ["uris"], :name => "index_current_words_on_uris"
  add_index "current_words", ["word"], :name => "index_current_words_on_word"

  create_table "definitions", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",      :default => 1, :null => false
    t.text     "text",                         :null => false
    t.string   "source"
    t.string   "uri"
    t.integer  "definition_id",                :null => false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "definitions", ["approved_at"], :name => "index_definitions_on_approved_at"
  add_index "definitions", ["approver_id"], :name => "index_definitions_on_approver_id"
  add_index "definitions", ["author_id"], :name => "index_definitions_on_author_id"
  add_index "definitions", ["created_at"], :name => "index_definitions_on_created_at"
  add_index "definitions", ["definition_id"], :name => "index_definitions_on_definition_id"
  add_index "definitions", ["deleted_at"], :name => "index_definitions_on_deleted_at"
  add_index "definitions", ["revision"], :name => "index_definitions_on_revision"
  add_index "definitions", ["source"], :name => "index_definitions_on_source"
  add_index "definitions", ["uri"], :name => "index_definitions_on_uri"

  create_table "samples", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "text",                       :null => false
    t.string   "source"
    t.string   "uri"
    t.integer  "sample_id",                  :null => false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "samples", ["approved_at"], :name => "index_samples_on_approved_at"
  add_index "samples", ["approver_id"], :name => "index_samples_on_approver_id"
  add_index "samples", ["author_id"], :name => "index_samples_on_author_id"
  add_index "samples", ["created_at"], :name => "index_samples_on_created_at"
  add_index "samples", ["deleted_at"], :name => "index_samples_on_deleted_at"
  add_index "samples", ["revision"], :name => "index_samples_on_revision"
  add_index "samples", ["sample_id"], :name => "index_samples_on_sample_id"
  add_index "samples", ["source"], :name => "index_samples_on_source"
  add_index "samples", ["uri"], :name => "index_samples_on_uri"

  create_table "synset_words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",       :default => 1,  :null => false
    t.integer  "word_id",                        :null => false
    t.boolean  "nsg"
    t.string   "marks",          :default => [],                 :array => true
    t.integer  "samples_ids",    :default => [],                 :array => true
    t.integer  "synset_word_id",                 :null => false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "synset_words", ["approved_at"], :name => "index_synset_words_on_approved_at"
  add_index "synset_words", ["approver_id"], :name => "index_synset_words_on_approver_id"
  add_index "synset_words", ["author_id"], :name => "index_synset_words_on_author_id"
  add_index "synset_words", ["created_at"], :name => "index_synset_words_on_created_at"
  add_index "synset_words", ["deleted_at"], :name => "index_synset_words_on_deleted_at"
  add_index "synset_words", ["marks"], :name => "index_synset_words_on_marks"
  add_index "synset_words", ["nsg"], :name => "index_synset_words_on_nsg"
  add_index "synset_words", ["revision"], :name => "index_synset_words_on_revision"
  add_index "synset_words", ["synset_word_id"], :name => "index_synset_words_on_synset_word_id"
  add_index "synset_words", ["word_id"], :name => "index_synset_words_on_word_id"

  create_table "synsets", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",        :default => 1,  :null => false
    t.datetime "deleted_at"
    t.integer  "synset_id"
    t.datetime "created_at"
    t.integer  "words_ids",       :default => [],                 :array => true
    t.integer  "definitions_ids", :default => [],                 :array => true
  end

  add_index "synsets", ["approved_at"], :name => "index_synsets_on_approved_at"
  add_index "synsets", ["approver_id"], :name => "index_synsets_on_approver_id"
  add_index "synsets", ["author_id"], :name => "index_synsets_on_author_id"
  add_index "synsets", ["definitions_ids"], :name => "index_synsets_on_definitions_ids"
  add_index "synsets", ["deleted_at"], :name => "index_synsets_on_deleted_at"
  add_index "synsets", ["revision"], :name => "index_synsets_on_revision"
  add_index "synsets", ["synset_id"], :name => "index_synsets_on_synset_id"
  add_index "synsets", ["words_ids"], :name => "index_synsets_on_words_ids"

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
    t.datetime "created_at",                  :null => false
    t.integer  "revision",    :default => 1,  :null => false
    t.string   "word",                        :null => false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "word_id",                     :null => false
    t.integer  "accents",     :default => [],                 :array => true
    t.string   "uris",        :default => [],                 :array => true
    t.integer  "frequency",   :default => 0,  :null => false
  end

  add_index "words", ["accents"], :name => "index_words_on_accents"
  add_index "words", ["approved_at"], :name => "index_entries_on_approved_at"
  add_index "words", ["approver_id"], :name => "index_entries_on_approver_id"
  add_index "words", ["author_id"], :name => "index_entries_on_author_id"
  add_index "words", ["deleted_at"], :name => "index_entries_on_deleted_at"
  add_index "words", ["frequency"], :name => "index_words_on_frequency"
  add_index "words", ["grammar"], :name => "index_entries_on_grammar"
  add_index "words", ["revision"], :name => "index_entries_on_revision"
  add_index "words", ["uris"], :name => "index_words_on_uris"
  add_index "words", ["word"], :name => "index_words_on_word"
  add_index "words", ["word_id"], :name => "index_words_on_word_id"

  add_foreign_key "current_definitions", "users", :name => "current_definitions_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_definitions", "users", :name => "current_definitions_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_samples", "users", :name => "current_samples_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_samples", "users", :name => "current_samples_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_synset_words", "current_words", :name => "current_synset_words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "current_synset_words", "users", :name => "current_synset_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_synset_words", "users", :name => "current_synset_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_synsets", "users", :name => "current_synsets_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_synsets", "users", :name => "current_synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_words", "users", :name => "current_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_words", "users", :name => "current_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "definitions", "current_definitions", :name => "definitions_definition_id_fk", :column => "definition_id", :dependent => :delete
  add_foreign_key "definitions", "users", :name => "definitions_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "definitions", "users", :name => "definitions_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "samples", "current_samples", :name => "samples_sample_id_fk", :column => "sample_id", :dependent => :delete
  add_foreign_key "samples", "users", :name => "samples_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "samples", "users", :name => "samples_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synset_words", "current_synset_words", :name => "synset_words_synset_word_id_fk", :column => "synset_word_id", :dependent => :delete
  add_foreign_key "synset_words", "current_words", :name => "synset_words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "synset_words", "users", :name => "synset_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synset_words", "users", :name => "synset_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synsets", "current_synsets", :name => "synsets_synset_id_fk", :column => "synset_id", :dependent => :delete
  add_foreign_key "synsets", "users", :name => "synsets_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synsets", "users", :name => "synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "words", "current_words", :name => "words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_author_id_fk", :column => "author_id", :dependent => :delete

end
