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

ActiveRecord::Schema.define(:version => 20131104035800) do

  create_table "antonomy_relations", :force => true do |t|
    t.integer  "antonomy_relation_id",                :null => false
    t.integer  "synset1_id",                          :null => false
    t.integer  "synset2_id",                          :null => false
    t.integer  "word1_id",                            :null => false
    t.integer  "word2_id",                            :null => false
    t.integer  "author_id",                           :null => false
    t.integer  "revision",             :default => 1, :null => false
    t.integer  "approver_id",                         :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "antonomy_relations", ["antonomy_relation_id"], :name => "index_antonomy_relations_on_antonomy_relation_id"
  add_index "antonomy_relations", ["approved_at"], :name => "index_antonomy_relations_on_approved_at"
  add_index "antonomy_relations", ["approver_id"], :name => "index_antonomy_relations_on_approver_id"
  add_index "antonomy_relations", ["author_id"], :name => "index_antonomy_relations_on_author_id"
  add_index "antonomy_relations", ["deleted_at"], :name => "index_antonomy_relations_on_deleted_at"
  add_index "antonomy_relations", ["revision"], :name => "index_antonomy_relations_on_revision"
  add_index "antonomy_relations", ["synset1_id"], :name => "index_antonomy_relations_on_synset1_id"
  add_index "antonomy_relations", ["synset2_id"], :name => "index_antonomy_relations_on_synset2_id"
  add_index "antonomy_relations", ["updated_at"], :name => "index_antonomy_relations_on_updated_at"
  add_index "antonomy_relations", ["word1_id"], :name => "index_antonomy_relations_on_word1_id"
  add_index "antonomy_relations", ["word2_id"], :name => "index_antonomy_relations_on_word2_id"

  create_table "current_antonomy_relations", :force => true do |t|
    t.integer  "synset1_id",                 :null => false
    t.integer  "synset2_id",                 :null => false
    t.integer  "word1_id",                   :null => false
    t.integer  "word2_id",                   :null => false
    t.integer  "author_id",                  :null => false
    t.integer  "revision",    :default => 1, :null => false
    t.integer  "approver_id",                :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_antonomy_relations", ["approved_at"], :name => "index_current_antonomy_relations_on_approved_at"
  add_index "current_antonomy_relations", ["approver_id"], :name => "index_current_antonomy_relations_on_approver_id"
  add_index "current_antonomy_relations", ["author_id"], :name => "index_current_antonomy_relations_on_author_id"
  add_index "current_antonomy_relations", ["deleted_at"], :name => "index_current_antonomy_relations_on_deleted_at"
  add_index "current_antonomy_relations", ["revision"], :name => "index_current_antonomy_relations_on_revision"
  add_index "current_antonomy_relations", ["synset1_id"], :name => "index_current_antonomy_relations_on_synset1_id"
  add_index "current_antonomy_relations", ["synset2_id"], :name => "index_current_antonomy_relations_on_synset2_id"
  add_index "current_antonomy_relations", ["updated_at"], :name => "index_current_antonomy_relations_on_updated_at"
  add_index "current_antonomy_relations", ["word1_id"], :name => "index_current_antonomy_relations_on_word1_id"
  add_index "current_antonomy_relations", ["word2_id"], :name => "index_current_antonomy_relations_on_word2_id"

  create_table "current_definitions", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "text",                       :null => false
    t.text     "source"
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

  create_table "current_interlinks", :force => true do |t|
    t.integer  "synset_id",                  :null => false
    t.text     "pwn",                        :null => false
    t.integer  "author_id",                  :null => false
    t.integer  "revision",    :default => 1, :null => false
    t.integer  "approver_id",                :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_interlinks", ["approved_at"], :name => "index_current_interlinks_on_approved_at"
  add_index "current_interlinks", ["approver_id"], :name => "index_current_interlinks_on_approver_id"
  add_index "current_interlinks", ["author_id"], :name => "index_current_interlinks_on_author_id"
  add_index "current_interlinks", ["deleted_at"], :name => "index_current_interlinks_on_deleted_at"
  add_index "current_interlinks", ["pwn"], :name => "index_current_interlinks_on_pwn"
  add_index "current_interlinks", ["revision"], :name => "index_current_interlinks_on_revision"
  add_index "current_interlinks", ["synset_id"], :name => "index_current_interlinks_on_synset_id"
  add_index "current_interlinks", ["updated_at"], :name => "index_current_interlinks_on_updated_at"

  create_table "current_samples", :force => true do |t|
    t.text     "text",                       :null => false
    t.text     "source"
    t.string   "uri"
    t.integer  "author_id",                  :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
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

  create_table "current_synset_relations", :force => true do |t|
    t.integer  "synset1_id",                 :null => false
    t.integer  "synset2_id",                 :null => false
    t.integer  "author_id",                  :null => false
    t.integer  "revision",    :default => 1, :null => false
    t.integer  "approver_id",                :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_synset_relations", ["approved_at"], :name => "index_current_synset_relations_on_approved_at"
  add_index "current_synset_relations", ["approver_id"], :name => "index_current_synset_relations_on_approver_id"
  add_index "current_synset_relations", ["author_id"], :name => "index_current_synset_relations_on_author_id"
  add_index "current_synset_relations", ["deleted_at"], :name => "index_current_synset_relations_on_deleted_at"
  add_index "current_synset_relations", ["revision"], :name => "index_current_synset_relations_on_revision"
  add_index "current_synset_relations", ["synset1_id"], :name => "index_current_synset_relations_on_synset1_id"
  add_index "current_synset_relations", ["synset2_id"], :name => "index_current_synset_relations_on_synset2_id"
  add_index "current_synset_relations", ["updated_at"], :name => "index_current_synset_relations_on_updated_at"

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
    t.integer  "revision",              :default => 1,  :null => false
    t.datetime "deleted_at"
    t.datetime "updated_at"
    t.integer  "words_ids",             :default => [],                 :array => true
    t.integer  "definitions_ids",       :default => [],                 :array => true
    t.integer  "default_definition_id"
  end

  add_index "current_synsets", ["approved_at"], :name => "index_current_synsets_on_approved_at"
  add_index "current_synsets", ["approver_id"], :name => "index_current_synsets_on_approver_id"
  add_index "current_synsets", ["author_id"], :name => "index_current_synsets_on_author_id"
  add_index "current_synsets", ["default_definition_id"], :name => "index_current_synsets_on_default_definition_id"
  add_index "current_synsets", ["definitions_ids"], :name => "index_current_synsets_on_definitions_ids"
  add_index "current_synsets", ["deleted_at"], :name => "index_current_synsets_on_deleted_at"
  add_index "current_synsets", ["revision"], :name => "index_current_synsets_on_revision"
  add_index "current_synsets", ["words_ids"], :name => "index_current_synsets_on_words_ids"

  create_table "current_word_relations", :force => true do |t|
    t.integer  "word1_id",                   :null => false
    t.integer  "word2_id",                   :null => false
    t.integer  "author_id",                  :null => false
    t.integer  "revision",    :default => 1, :null => false
    t.integer  "approver_id",                :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_word_relations", ["approved_at"], :name => "index_current_word_relations_on_approved_at"
  add_index "current_word_relations", ["approver_id"], :name => "index_current_word_relations_on_approver_id"
  add_index "current_word_relations", ["author_id"], :name => "index_current_word_relations_on_author_id"
  add_index "current_word_relations", ["deleted_at"], :name => "index_current_word_relations_on_deleted_at"
  add_index "current_word_relations", ["revision"], :name => "index_current_word_relations_on_revision"
  add_index "current_word_relations", ["updated_at"], :name => "index_current_word_relations_on_updated_at"
  add_index "current_word_relations", ["word1_id"], :name => "index_current_word_relations_on_word1_id"
  add_index "current_word_relations", ["word2_id"], :name => "index_current_word_relations_on_word2_id"

  create_table "current_words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.string   "word",                         :null => false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "revision",    :default => 1
    t.integer  "accents",     :default => [],                  :array => true
    t.string   "uris",        :default => [],                  :array => true
    t.float    "frequency",   :default => 0.0, :null => false
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
    t.text     "source"
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

  create_table "interlinks", :force => true do |t|
    t.integer  "interlink_id",                :null => false
    t.integer  "synset_id",                   :null => false
    t.text     "pwn",                         :null => false
    t.integer  "author_id",                   :null => false
    t.integer  "revision",     :default => 1, :null => false
    t.integer  "approver_id",                 :null => false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "interlinks", ["approved_at"], :name => "index_interlinks_on_approved_at"
  add_index "interlinks", ["approver_id"], :name => "index_interlinks_on_approver_id"
  add_index "interlinks", ["author_id"], :name => "index_interlinks_on_author_id"
  add_index "interlinks", ["deleted_at"], :name => "index_interlinks_on_deleted_at"
  add_index "interlinks", ["interlink_id"], :name => "index_interlinks_on_interlink_id"
  add_index "interlinks", ["pwn"], :name => "index_interlinks_on_pwn"
  add_index "interlinks", ["revision"], :name => "index_interlinks_on_revision"
  add_index "interlinks", ["synset_id"], :name => "index_interlinks_on_synset_id"
  add_index "interlinks", ["updated_at"], :name => "index_interlinks_on_updated_at"

  create_table "mark_categories", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mark_categories", ["title"], :name => "index_mark_categories_on_title", :unique => true

  create_table "marks", :force => true do |t|
    t.string   "name",             :null => false
    t.string   "description",      :null => false
    t.integer  "mark_category_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "marks", ["mark_category_id"], :name => "index_marks_on_mark_category_id"
  add_index "marks", ["name"], :name => "index_marks_on_name", :unique => true

  create_table "raw_synset_words", :force => true do |t|
    t.integer  "word_id",                     :null => false
    t.string   "nsg"
    t.string   "marks",       :default => [], :null => false, :array => true
    t.integer  "samples_ids", :default => [], :null => false, :array => true
    t.integer  "author_id",                   :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "raw_synset_words", ["author_id"], :name => "index_raw_synset_words_on_author_id"
  add_index "raw_synset_words", ["marks"], :name => "index_raw_synset_words_on_marks"
  add_index "raw_synset_words", ["nsg"], :name => "index_raw_synset_words_on_nsg"
  add_index "raw_synset_words", ["samples_ids"], :name => "index_raw_synset_words_on_samples_ids"
  add_index "raw_synset_words", ["word_id"], :name => "index_raw_synset_words_on_word_id"

  create_table "raw_synsets", :force => true do |t|
    t.integer  "words_ids",       :default => [], :null => false, :array => true
    t.integer  "definitions_ids", :default => [], :null => false, :array => true
    t.integer  "author_id",                       :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "raw_synsets", ["author_id"], :name => "index_raw_synsets_on_author_id"
  add_index "raw_synsets", ["definitions_ids"], :name => "index_raw_synsets_on_definitions_ids"
  add_index "raw_synsets", ["words_ids"], :name => "index_raw_synsets_on_words_ids"

  create_table "samples", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    :default => 1, :null => false
    t.text     "text",                       :null => false
    t.text     "source"
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

  create_table "synset_relations", :force => true do |t|
    t.integer  "synset_relation_id",                :null => false
    t.integer  "synset1_id",                        :null => false
    t.integer  "synset2_id",                        :null => false
    t.integer  "author_id",                         :null => false
    t.integer  "revision",           :default => 1, :null => false
    t.integer  "approver_id",                       :null => false
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "synset_relations", ["approved_at"], :name => "index_synset_relations_on_approved_at"
  add_index "synset_relations", ["approver_id"], :name => "index_synset_relations_on_approver_id"
  add_index "synset_relations", ["author_id"], :name => "index_synset_relations_on_author_id"
  add_index "synset_relations", ["created_at"], :name => "index_synset_relations_on_created_at"
  add_index "synset_relations", ["deleted_at"], :name => "index_synset_relations_on_deleted_at"
  add_index "synset_relations", ["revision"], :name => "index_synset_relations_on_revision"
  add_index "synset_relations", ["synset1_id"], :name => "index_synset_relations_on_synset1_id"
  add_index "synset_relations", ["synset2_id"], :name => "index_synset_relations_on_synset2_id"
  add_index "synset_relations", ["synset_relation_id"], :name => "index_synset_relations_on_synset_relation_id"

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

  create_table "word_relations", :force => true do |t|
    t.integer  "word_relation_id",                :null => false
    t.integer  "word1_id",                        :null => false
    t.integer  "word2_id",                        :null => false
    t.integer  "author_id",                       :null => false
    t.integer  "revision",         :default => 1, :null => false
    t.integer  "approver_id",                     :null => false
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "word_relations", ["approved_at"], :name => "index_word_relations_on_approved_at"
  add_index "word_relations", ["approver_id"], :name => "index_word_relations_on_approver_id"
  add_index "word_relations", ["author_id"], :name => "index_word_relations_on_author_id"
  add_index "word_relations", ["created_at"], :name => "index_word_relations_on_created_at"
  add_index "word_relations", ["deleted_at"], :name => "index_word_relations_on_deleted_at"
  add_index "word_relations", ["revision"], :name => "index_word_relations_on_revision"
  add_index "word_relations", ["word1_id"], :name => "index_word_relations_on_word1_id"
  add_index "word_relations", ["word2_id"], :name => "index_word_relations_on_word2_id"
  add_index "word_relations", ["word_relation_id"], :name => "index_word_relations_on_word_relation_id"

  create_table "words", :force => true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "created_at",                   :null => false
    t.integer  "revision",    :default => 1,   :null => false
    t.string   "word",                         :null => false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "word_id",                      :null => false
    t.integer  "accents",     :default => [],                  :array => true
    t.string   "uris",        :default => [],                  :array => true
    t.float    "frequency",   :default => 0.0, :null => false
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

  add_foreign_key "antonomy_relations", "current_antonomy_relations", :name => "antonomy_relations_antonomy_relation_id_fk", :column => "antonomy_relation_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "current_synsets", :name => "antonomy_relations_synset1_id_fk", :column => "synset1_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "current_synsets", :name => "antonomy_relations_synset2_id_fk", :column => "synset2_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "current_words", :name => "antonomy_relations_word1_id_fk", :column => "word1_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "current_words", :name => "antonomy_relations_word2_id_fk", :column => "word2_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "users", :name => "antonomy_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "antonomy_relations", "users", :name => "antonomy_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_antonomy_relations", "current_synsets", :name => "current_antonomy_relations_synset1_id_fk", :column => "synset1_id", :dependent => :delete
  add_foreign_key "current_antonomy_relations", "current_synsets", :name => "current_antonomy_relations_synset2_id_fk", :column => "synset2_id", :dependent => :delete
  add_foreign_key "current_antonomy_relations", "current_words", :name => "current_antonomy_relations_word1_id_fk", :column => "word1_id", :dependent => :delete
  add_foreign_key "current_antonomy_relations", "current_words", :name => "current_antonomy_relations_word2_id_fk", :column => "word2_id", :dependent => :delete
  add_foreign_key "current_antonomy_relations", "users", :name => "current_antonomy_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_antonomy_relations", "users", :name => "current_antonomy_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_definitions", "users", :name => "current_definitions_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_definitions", "users", :name => "current_definitions_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_interlinks", "current_synsets", :name => "current_interlinks_synset_id_fk", :column => "synset_id", :dependent => :delete
  add_foreign_key "current_interlinks", "users", :name => "current_interlinks_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_interlinks", "users", :name => "current_interlinks_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_samples", "users", :name => "current_samples_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_samples", "users", :name => "current_samples_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_synset_relations", "current_synsets", :name => "current_synset_relations_synset1_id_fk", :column => "synset1_id", :dependent => :delete
  add_foreign_key "current_synset_relations", "current_synsets", :name => "current_synset_relations_synset2_id_fk", :column => "synset2_id", :dependent => :delete
  add_foreign_key "current_synset_relations", "users", :name => "current_synset_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_synset_relations", "users", :name => "current_synset_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_synset_words", "current_words", :name => "current_synset_words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "current_synset_words", "users", :name => "current_synset_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_synset_words", "users", :name => "current_synset_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_synsets", "current_definitions", :name => "current_synsets_default_definition_id_fk", :column => "default_definition_id"
  add_foreign_key "current_synsets", "users", :name => "current_synsets_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_synsets", "users", :name => "current_synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_word_relations", "current_words", :name => "current_word_relations_word1_id_fk", :column => "word1_id", :dependent => :delete
  add_foreign_key "current_word_relations", "current_words", :name => "current_word_relations_word2_id_fk", :column => "word2_id", :dependent => :delete
  add_foreign_key "current_word_relations", "users", :name => "current_word_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_word_relations", "users", :name => "current_word_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "current_words", "users", :name => "current_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "current_words", "users", :name => "current_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "definitions", "current_definitions", :name => "definitions_definition_id_fk", :column => "definition_id", :dependent => :delete
  add_foreign_key "definitions", "users", :name => "definitions_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "definitions", "users", :name => "definitions_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "interlinks", "current_interlinks", :name => "interlinks_interlink_id_fk", :column => "interlink_id", :dependent => :delete
  add_foreign_key "interlinks", "current_synsets", :name => "interlinks_synset_id_fk", :column => "synset_id", :dependent => :delete
  add_foreign_key "interlinks", "users", :name => "interlinks_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "interlinks", "users", :name => "interlinks_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "marks", "mark_categories", :name => "marks_mark_category_id_fk", :dependent => :delete

  add_foreign_key "raw_synset_words", "current_words", :name => "raw_synset_words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "raw_synset_words", "users", :name => "raw_synset_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "raw_synsets", "users", :name => "raw_synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "samples", "current_samples", :name => "samples_sample_id_fk", :column => "sample_id", :dependent => :delete
  add_foreign_key "samples", "users", :name => "samples_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "samples", "users", :name => "samples_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synset_relations", "current_synset_relations", :name => "synset_relations_synset_relation_id_fk", :column => "synset_relation_id", :dependent => :delete
  add_foreign_key "synset_relations", "current_synsets", :name => "synset_relations_synset1_id_fk", :column => "synset1_id", :dependent => :delete
  add_foreign_key "synset_relations", "current_synsets", :name => "synset_relations_synset2_id_fk", :column => "synset2_id", :dependent => :delete
  add_foreign_key "synset_relations", "users", :name => "synset_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synset_relations", "users", :name => "synset_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synset_words", "current_synset_words", :name => "synset_words_synset_word_id_fk", :column => "synset_word_id", :dependent => :delete
  add_foreign_key "synset_words", "current_words", :name => "synset_words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "synset_words", "users", :name => "synset_words_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synset_words", "users", :name => "synset_words_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "synsets", "current_synsets", :name => "synsets_synset_id_fk", :column => "synset_id", :dependent => :delete
  add_foreign_key "synsets", "users", :name => "synsets_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "synsets", "users", :name => "synsets_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "word_relations", "current_word_relations", :name => "word_relations_word_relation_id_fk", :column => "word_relation_id", :dependent => :delete
  add_foreign_key "word_relations", "current_words", :name => "word_relations_word1_id_fk", :column => "word1_id", :dependent => :delete
  add_foreign_key "word_relations", "current_words", :name => "word_relations_word2_id_fk", :column => "word2_id", :dependent => :delete
  add_foreign_key "word_relations", "users", :name => "word_relations_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "word_relations", "users", :name => "word_relations_author_id_fk", :column => "author_id", :dependent => :delete

  add_foreign_key "words", "current_words", :name => "words_word_id_fk", :column => "word_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_approver_id_fk", :column => "approver_id", :dependent => :delete
  add_foreign_key "words", "users", :name => "entries_author_id_fk", :column => "author_id", :dependent => :delete

end
