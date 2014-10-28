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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141028204732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pg_stat_statements"

  create_table "antonomy_relations", force: true do |t|
    t.integer  "antonomy_relation_id",             null: false
    t.integer  "synset1_id",                       null: false
    t.integer  "synset2_id",                       null: false
    t.integer  "word1_id",                         null: false
    t.integer  "word2_id",                         null: false
    t.integer  "author_id",                        null: false
    t.integer  "revision",             default: 1, null: false
    t.integer  "approver_id",                      null: false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "antonomy_relations", ["antonomy_relation_id"], name: "index_antonomy_relations_on_antonomy_relation_id", using: :btree
  add_index "antonomy_relations", ["approved_at"], name: "index_antonomy_relations_on_approved_at", using: :btree
  add_index "antonomy_relations", ["approver_id"], name: "index_antonomy_relations_on_approver_id", using: :btree
  add_index "antonomy_relations", ["author_id"], name: "index_antonomy_relations_on_author_id", using: :btree
  add_index "antonomy_relations", ["deleted_at"], name: "index_antonomy_relations_on_deleted_at", using: :btree
  add_index "antonomy_relations", ["revision"], name: "index_antonomy_relations_on_revision", using: :btree
  add_index "antonomy_relations", ["synset1_id"], name: "index_antonomy_relations_on_synset1_id", using: :btree
  add_index "antonomy_relations", ["synset2_id"], name: "index_antonomy_relations_on_synset2_id", using: :btree
  add_index "antonomy_relations", ["updated_at"], name: "index_antonomy_relations_on_updated_at", using: :btree
  add_index "antonomy_relations", ["word1_id"], name: "index_antonomy_relations_on_word1_id", using: :btree
  add_index "antonomy_relations", ["word2_id"], name: "index_antonomy_relations_on_word2_id", using: :btree

  create_table "badges_sashes", force: true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "current_antonomy_relations", force: true do |t|
    t.integer  "synset1_id",              null: false
    t.integer  "synset2_id",              null: false
    t.integer  "word1_id",                null: false
    t.integer  "word2_id",                null: false
    t.integer  "author_id",               null: false
    t.integer  "revision",    default: 1, null: false
    t.integer  "approver_id",             null: false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_antonomy_relations", ["approved_at"], name: "index_current_antonomy_relations_on_approved_at", using: :btree
  add_index "current_antonomy_relations", ["approver_id"], name: "index_current_antonomy_relations_on_approver_id", using: :btree
  add_index "current_antonomy_relations", ["author_id"], name: "index_current_antonomy_relations_on_author_id", using: :btree
  add_index "current_antonomy_relations", ["deleted_at"], name: "index_current_antonomy_relations_on_deleted_at", using: :btree
  add_index "current_antonomy_relations", ["revision"], name: "index_current_antonomy_relations_on_revision", using: :btree
  add_index "current_antonomy_relations", ["synset1_id"], name: "index_current_antonomy_relations_on_synset1_id", using: :btree
  add_index "current_antonomy_relations", ["synset2_id"], name: "index_current_antonomy_relations_on_synset2_id", using: :btree
  add_index "current_antonomy_relations", ["updated_at"], name: "index_current_antonomy_relations_on_updated_at", using: :btree
  add_index "current_antonomy_relations", ["word1_id"], name: "index_current_antonomy_relations_on_word1_id", using: :btree
  add_index "current_antonomy_relations", ["word2_id"], name: "index_current_antonomy_relations_on_word2_id", using: :btree

  create_table "current_definitions", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    default: 1, null: false
    t.text     "text",                    null: false
    t.text     "source"
    t.string   "uri"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_definitions", ["approved_at"], name: "index_current_definitions_on_approved_at", using: :btree
  add_index "current_definitions", ["approver_id"], name: "index_current_definitions_on_approver_id", using: :btree
  add_index "current_definitions", ["author_id"], name: "index_current_definitions_on_author_id", using: :btree
  add_index "current_definitions", ["deleted_at"], name: "index_current_definitions_on_deleted_at", using: :btree
  add_index "current_definitions", ["revision"], name: "index_current_definitions_on_revision", using: :btree
  add_index "current_definitions", ["source"], name: "index_current_definitions_on_source", using: :btree
  add_index "current_definitions", ["updated_at"], name: "index_current_definitions_on_updated_at", using: :btree
  add_index "current_definitions", ["uri"], name: "index_current_definitions_on_uri", using: :btree

  create_table "current_examples", force: true do |t|
    t.text     "text",                    null: false
    t.text     "source"
    t.string   "uri"
    t.integer  "author_id",               null: false
    t.datetime "updated_at",              null: false
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    default: 1, null: false
    t.datetime "deleted_at"
  end

  add_index "current_examples", ["approved_at"], name: "index_current_examples_on_approved_at", using: :btree
  add_index "current_examples", ["approver_id"], name: "index_current_examples_on_approver_id", using: :btree
  add_index "current_examples", ["author_id"], name: "index_current_examples_on_author_id", using: :btree
  add_index "current_examples", ["deleted_at"], name: "index_current_examples_on_deleted_at", using: :btree
  add_index "current_examples", ["revision"], name: "index_current_examples_on_revision", using: :btree
  add_index "current_examples", ["source"], name: "index_current_examples_on_source", using: :btree
  add_index "current_examples", ["updated_at"], name: "index_current_examples_on_updated_at", using: :btree
  add_index "current_examples", ["uri"], name: "index_current_examples_on_uri", using: :btree

  create_table "current_interlanguage_relations", force: true do |t|
    t.integer  "synset_id",               null: false
    t.text     "pwn",                     null: false
    t.integer  "author_id",               null: false
    t.integer  "revision",    default: 1, null: false
    t.integer  "approver_id",             null: false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_interlanguage_relations", ["approved_at"], name: "index_current_interlanguage_relations_on_approved_at", using: :btree
  add_index "current_interlanguage_relations", ["approver_id"], name: "index_current_interlanguage_relations_on_approver_id", using: :btree
  add_index "current_interlanguage_relations", ["author_id"], name: "index_current_interlanguage_relations_on_author_id", using: :btree
  add_index "current_interlanguage_relations", ["deleted_at"], name: "index_current_interlanguage_relations_on_deleted_at", using: :btree
  add_index "current_interlanguage_relations", ["pwn"], name: "index_current_interlanguage_relations_on_pwn", using: :btree
  add_index "current_interlanguage_relations", ["revision"], name: "index_current_interlanguage_relations_on_revision", using: :btree
  add_index "current_interlanguage_relations", ["synset_id"], name: "index_current_interlanguage_relations_on_synset_id", using: :btree
  add_index "current_interlanguage_relations", ["updated_at"], name: "index_current_interlanguage_relations_on_updated_at", using: :btree

  create_table "current_synset_interlinks", force: true do |t|
    t.integer  "synset_id",               null: false
    t.text     "source",                  null: false
    t.text     "foreign_id"
    t.integer  "author_id",               null: false
    t.integer  "revision",    default: 1, null: false
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_synset_interlinks", ["approved_at"], name: "index_current_synset_interlinks_on_approved_at", using: :btree
  add_index "current_synset_interlinks", ["approver_id"], name: "index_current_synset_interlinks_on_approver_id", using: :btree
  add_index "current_synset_interlinks", ["author_id"], name: "index_current_synset_interlinks_on_author_id", using: :btree
  add_index "current_synset_interlinks", ["deleted_at"], name: "index_current_synset_interlinks_on_deleted_at", using: :btree
  add_index "current_synset_interlinks", ["foreign_id"], name: "index_current_synset_interlinks_on_foreign_id", using: :btree
  add_index "current_synset_interlinks", ["revision"], name: "index_current_synset_interlinks_on_revision", using: :btree
  add_index "current_synset_interlinks", ["source"], name: "index_current_synset_interlinks_on_source", using: :btree
  add_index "current_synset_interlinks", ["synset_id"], name: "index_current_synset_interlinks_on_synset_id", using: :btree
  add_index "current_synset_interlinks", ["updated_at"], name: "index_current_synset_interlinks_on_updated_at", using: :btree

  create_table "current_synset_relations", force: true do |t|
    t.integer  "synset1_id",              null: false
    t.integer  "synset2_id",              null: false
    t.integer  "author_id",               null: false
    t.integer  "revision",    default: 1, null: false
    t.integer  "approver_id",             null: false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_synset_relations", ["approved_at"], name: "index_current_synset_relations_on_approved_at", using: :btree
  add_index "current_synset_relations", ["approver_id"], name: "index_current_synset_relations_on_approver_id", using: :btree
  add_index "current_synset_relations", ["author_id"], name: "index_current_synset_relations_on_author_id", using: :btree
  add_index "current_synset_relations", ["deleted_at"], name: "index_current_synset_relations_on_deleted_at", using: :btree
  add_index "current_synset_relations", ["revision"], name: "index_current_synset_relations_on_revision", using: :btree
  add_index "current_synset_relations", ["synset1_id"], name: "index_current_synset_relations_on_synset1_id", using: :btree
  add_index "current_synset_relations", ["synset2_id"], name: "index_current_synset_relations_on_synset2_id", using: :btree
  add_index "current_synset_relations", ["updated_at"], name: "index_current_synset_relations_on_updated_at", using: :btree

  create_table "current_synset_words", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",        default: 1,  null: false
    t.integer  "word_id",                      null: false
    t.boolean  "nsg"
    t.integer  "examples_ids",    default: [],              array: true
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "marks_ids",       default: [], null: false, array: true
    t.integer  "definitions_ids", default: [],              array: true
  end

  add_index "current_synset_words", ["approved_at"], name: "index_current_synset_words_on_approved_at", using: :btree
  add_index "current_synset_words", ["approver_id"], name: "index_current_synset_words_on_approver_id", using: :btree
  add_index "current_synset_words", ["author_id"], name: "index_current_synset_words_on_author_id", using: :btree
  add_index "current_synset_words", ["definitions_ids"], name: "index_current_synset_words_on_definitions_ids", using: :gin
  add_index "current_synset_words", ["deleted_at"], name: "index_current_synset_words_on_deleted_at", using: :btree
  add_index "current_synset_words", ["examples_ids"], name: "index_current_synset_words_on_examples_ids", using: :gin
  add_index "current_synset_words", ["marks_ids"], name: "index_current_synset_words_on_marks_ids", using: :gin
  add_index "current_synset_words", ["nsg"], name: "index_current_synset_words_on_nsg", using: :btree
  add_index "current_synset_words", ["revision"], name: "index_current_synset_words_on_revision", using: :btree
  add_index "current_synset_words", ["updated_at"], name: "index_current_synset_words_on_updated_at", using: :btree
  add_index "current_synset_words", ["word_id"], name: "index_current_synset_words_on_word_id", using: :btree

  create_table "current_synsets", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",               default: 1,  null: false
    t.datetime "deleted_at"
    t.datetime "updated_at"
    t.integer  "words_ids",              default: [],              array: true
    t.integer  "default_definition_id"
    t.integer  "default_synset_word_id"
  end

  add_index "current_synsets", ["approved_at"], name: "index_current_synsets_on_approved_at", using: :btree
  add_index "current_synsets", ["approver_id"], name: "index_current_synsets_on_approver_id", using: :btree
  add_index "current_synsets", ["author_id"], name: "index_current_synsets_on_author_id", using: :btree
  add_index "current_synsets", ["default_definition_id"], name: "index_current_synsets_on_default_definition_id", using: :btree
  add_index "current_synsets", ["default_synset_word_id"], name: "index_current_synsets_on_default_synset_word_id", using: :btree
  add_index "current_synsets", ["deleted_at"], name: "index_current_synsets_on_deleted_at", using: :btree
  add_index "current_synsets", ["revision"], name: "index_current_synsets_on_revision", using: :btree
  add_index "current_synsets", ["words_ids"], name: "index_current_synsets_on_words_ids", using: :gin

  create_table "current_word_relations", force: true do |t|
    t.integer  "word1_id",                null: false
    t.integer  "word2_id",                null: false
    t.integer  "author_id",               null: false
    t.integer  "revision",    default: 1, null: false
    t.integer  "approver_id",             null: false
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "current_word_relations", ["approved_at"], name: "index_current_word_relations_on_approved_at", using: :btree
  add_index "current_word_relations", ["approver_id"], name: "index_current_word_relations_on_approver_id", using: :btree
  add_index "current_word_relations", ["author_id"], name: "index_current_word_relations_on_author_id", using: :btree
  add_index "current_word_relations", ["deleted_at"], name: "index_current_word_relations_on_deleted_at", using: :btree
  add_index "current_word_relations", ["revision"], name: "index_current_word_relations_on_revision", using: :btree
  add_index "current_word_relations", ["updated_at"], name: "index_current_word_relations_on_updated_at", using: :btree
  add_index "current_word_relations", ["word1_id"], name: "index_current_word_relations_on_word1_id", using: :btree
  add_index "current_word_relations", ["word2_id"], name: "index_current_word_relations_on_word2_id", using: :btree

  create_table "current_words", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.string   "word",                      null: false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "revision",    default: 1
    t.integer  "accents",     default: [],               array: true
    t.string   "uris",        default: [],               array: true
    t.float    "frequency",   default: 0.0, null: false
  end

  add_index "current_words", ["accents"], name: "index_current_words_on_accents", using: :btree
  add_index "current_words", ["approved_at"], name: "index_current_words_on_approved_at", using: :btree
  add_index "current_words", ["approver_id"], name: "index_current_words_on_approver_id", using: :btree
  add_index "current_words", ["author_id"], name: "index_current_words_on_author_id", using: :btree
  add_index "current_words", ["deleted_at"], name: "index_current_words_on_deleted_at", using: :btree
  add_index "current_words", ["frequency"], name: "index_current_words_on_frequency", using: :btree
  add_index "current_words", ["grammar"], name: "index_current_words_on_grammar", using: :btree
  add_index "current_words", ["revision"], name: "index_current_words_on_revision", using: :btree
  add_index "current_words", ["uris"], name: "index_current_words_on_uris", using: :btree
  add_index "current_words", ["word"], name: "index_current_words_on_word", using: :btree
  add_index "current_words", ["word"], name: "index_current_words_on_word_trgm", using: :gin

  create_table "definitions", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",      default: 1, null: false
    t.text     "text",                      null: false
    t.text     "source"
    t.string   "uri"
    t.integer  "definition_id",             null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "definitions", ["approved_at"], name: "index_definitions_on_approved_at", using: :btree
  add_index "definitions", ["approver_id"], name: "index_definitions_on_approver_id", using: :btree
  add_index "definitions", ["author_id"], name: "index_definitions_on_author_id", using: :btree
  add_index "definitions", ["created_at"], name: "index_definitions_on_created_at", using: :btree
  add_index "definitions", ["definition_id"], name: "index_definitions_on_definition_id", using: :btree
  add_index "definitions", ["deleted_at"], name: "index_definitions_on_deleted_at", using: :btree
  add_index "definitions", ["revision"], name: "index_definitions_on_revision", using: :btree
  add_index "definitions", ["source"], name: "index_definitions_on_source", using: :btree
  add_index "definitions", ["uri"], name: "index_definitions_on_uri", using: :btree

  create_table "domains", force: true do |t|
    t.string   "name",       null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["author_id"], name: "index_domains_on_author_id", using: :btree
  add_index "domains", ["name"], name: "index_domains_on_name", unique: true, using: :btree

  create_table "examples", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",    default: 1, null: false
    t.text     "text",                    null: false
    t.text     "source"
    t.string   "uri"
    t.integer  "example_id",              null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "examples", ["approved_at"], name: "index_examples_on_approved_at", using: :btree
  add_index "examples", ["approver_id"], name: "index_examples_on_approver_id", using: :btree
  add_index "examples", ["author_id"], name: "index_examples_on_author_id", using: :btree
  add_index "examples", ["created_at"], name: "index_examples_on_created_at", using: :btree
  add_index "examples", ["deleted_at"], name: "index_examples_on_deleted_at", using: :btree
  add_index "examples", ["example_id"], name: "index_examples_on_example_id", using: :btree
  add_index "examples", ["revision"], name: "index_examples_on_revision", using: :btree
  add_index "examples", ["source"], name: "index_examples_on_source", using: :btree
  add_index "examples", ["uri"], name: "index_examples_on_uri", using: :btree

  create_table "interlanguage_relations", force: true do |t|
    t.integer  "interlanguage_relation_id",             null: false
    t.integer  "synset_id",                             null: false
    t.text     "pwn",                                   null: false
    t.integer  "author_id",                             null: false
    t.integer  "revision",                  default: 1, null: false
    t.integer  "approver_id",                           null: false
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "interlanguage_relations", ["approved_at"], name: "index_interlanguage_relations_on_approved_at", using: :btree
  add_index "interlanguage_relations", ["approver_id"], name: "index_interlanguage_relations_on_approver_id", using: :btree
  add_index "interlanguage_relations", ["author_id"], name: "index_interlanguage_relations_on_author_id", using: :btree
  add_index "interlanguage_relations", ["created_at"], name: "index_interlanguage_relations_on_created_at", using: :btree
  add_index "interlanguage_relations", ["deleted_at"], name: "index_interlanguage_relations_on_deleted_at", using: :btree
  add_index "interlanguage_relations", ["interlanguage_relation_id"], name: "index_interlanguage_relations_on_interlanguage_relation_id", using: :btree
  add_index "interlanguage_relations", ["pwn"], name: "index_interlanguage_relations_on_pwn", using: :btree
  add_index "interlanguage_relations", ["revision"], name: "index_interlanguage_relations_on_revision", using: :btree
  add_index "interlanguage_relations", ["synset_id"], name: "index_interlanguage_relations_on_synset_id", using: :btree

  create_table "mark_categories", force: true do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mark_categories", ["title"], name: "index_mark_categories_on_title", unique: true, using: :btree

  create_table "marks", force: true do |t|
    t.string   "name",             null: false
    t.string   "description",      null: false
    t.integer  "mark_category_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "marks", ["mark_category_id"], name: "index_marks_on_mark_category_id", using: :btree
  add_index "marks", ["name"], name: "index_marks_on_name", unique: true, using: :btree

  create_table "merit_actions", force: true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: true do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: true do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "posts", force: true do |t|
    t.text     "title",      null: false
    t.text     "body",       null: false
    t.text     "slug"
    t.integer  "author_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "raw_definitions", force: true do |t|
    t.integer  "word_id",       null: false
    t.integer  "definition_id", null: false
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "raw_definitions", ["author_id"], name: "index_raw_definitions_on_author_id", using: :btree
  add_index "raw_definitions", ["definition_id"], name: "index_raw_definitions_on_definition_id", using: :btree
  add_index "raw_definitions", ["word_id"], name: "index_raw_definitions_on_word_id", using: :btree

  create_table "raw_examples", force: true do |t|
    t.integer  "raw_definition_id", null: false
    t.integer  "example_id",        null: false
    t.integer  "author_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "raw_examples", ["author_id"], name: "index_raw_examples_on_author_id", using: :btree
  add_index "raw_examples", ["example_id"], name: "index_raw_examples_on_example_id", using: :btree
  add_index "raw_examples", ["raw_definition_id"], name: "index_raw_examples_on_raw_definition_id", using: :btree

  create_table "raw_subsumptions", force: true do |t|
    t.integer  "hypernym_id", null: false
    t.integer  "hyponym_id",  null: false
    t.text     "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raw_subsumptions", ["created_at"], name: "index_raw_subsumptions_on_created_at", using: :btree
  add_index "raw_subsumptions", ["hypernym_id", "hyponym_id", "source"], name: "index_raw_subsumptions_on_hypernym_id_and_hyponym_id_and_source", unique: true, using: :btree
  add_index "raw_subsumptions", ["hypernym_id"], name: "index_raw_subsumptions_on_hypernym_id", using: :btree
  add_index "raw_subsumptions", ["hyponym_id"], name: "index_raw_subsumptions_on_hyponym_id", using: :btree
  add_index "raw_subsumptions", ["updated_at"], name: "index_raw_subsumptions_on_updated_at", using: :btree

  create_table "raw_synonymies", force: true do |t|
    t.integer  "word1_id",   null: false
    t.integer  "word2_id",   null: false
    t.integer  "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "raw_synonymies", ["author_id"], name: "index_raw_synonymies_on_author_id", using: :btree
  add_index "raw_synonymies", ["word1_id", "word2_id"], name: "index_raw_synonymies_on_word1_id_and_word2_id", unique: true, using: :btree
  add_index "raw_synonymies", ["word1_id"], name: "index_raw_synonymies_on_word1_id", using: :btree
  add_index "raw_synonymies", ["word2_id"], name: "index_raw_synonymies_on_word2_id", using: :btree

  create_table "raw_synset_words", force: true do |t|
    t.integer  "word_id",                   null: false
    t.string   "nsg"
    t.string   "marks",        default: [], null: false, array: true
    t.integer  "examples_ids", default: [], null: false, array: true
    t.integer  "author_id",                 null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "raw_synset_words", ["author_id"], name: "index_raw_synset_words_on_author_id", using: :btree
  add_index "raw_synset_words", ["examples_ids"], name: "index_raw_synset_words_on_examples_ids", using: :btree
  add_index "raw_synset_words", ["marks"], name: "index_raw_synset_words_on_marks", using: :btree
  add_index "raw_synset_words", ["nsg"], name: "index_raw_synset_words_on_nsg", using: :btree
  add_index "raw_synset_words", ["word_id"], name: "index_raw_synset_words_on_word_id", using: :btree

  create_table "raw_synsets", force: true do |t|
    t.integer  "words_ids",       default: [], null: false, array: true
    t.integer  "definitions_ids", default: [], null: false, array: true
    t.integer  "author_id",                    null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "raw_synsets", ["author_id"], name: "index_raw_synsets_on_author_id", using: :btree
  add_index "raw_synsets", ["definitions_ids"], name: "index_raw_synsets_on_definitions_ids", using: :gin
  add_index "raw_synsets", ["words_ids"], name: "index_raw_synsets_on_words_ids", using: :gin

  create_table "sashes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subsumption_answers", force: true do |t|
    t.integer  "raw_subsumption_id", null: false
    t.integer  "user_id",            null: false
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subsumption_answers", ["answer"], name: "index_subsumption_answers_on_answer", using: :btree
  add_index "subsumption_answers", ["created_at"], name: "index_subsumption_answers_on_created_at", using: :btree
  add_index "subsumption_answers", ["raw_subsumption_id", "user_id"], name: "index_subsumption_answers_on_raw_subsumption_id_and_user_id", unique: true, using: :btree
  add_index "subsumption_answers", ["raw_subsumption_id"], name: "index_subsumption_answers_on_raw_subsumption_id", using: :btree
  add_index "subsumption_answers", ["updated_at"], name: "index_subsumption_answers_on_updated_at", using: :btree
  add_index "subsumption_answers", ["user_id"], name: "index_subsumption_answers_on_user_id", using: :btree

  create_table "synset_domains", force: true do |t|
    t.integer  "domain_id",  null: false
    t.integer  "synset_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "synset_domains", ["domain_id"], name: "index_synset_domains_on_domain_id", using: :btree
  add_index "synset_domains", ["synset_id"], name: "index_synset_domains_on_synset_id", using: :btree

  create_table "synset_interlinks", force: true do |t|
    t.integer  "synset_interlink_id",             null: false
    t.integer  "synset_id",                       null: false
    t.text     "source",                          null: false
    t.text     "foreign_id"
    t.integer  "author_id",                       null: false
    t.integer  "revision",            default: 1, null: false
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "synset_interlinks", ["approved_at"], name: "index_synset_interlinks_on_approved_at", using: :btree
  add_index "synset_interlinks", ["approver_id"], name: "index_synset_interlinks_on_approver_id", using: :btree
  add_index "synset_interlinks", ["author_id"], name: "index_synset_interlinks_on_author_id", using: :btree
  add_index "synset_interlinks", ["deleted_at"], name: "index_synset_interlinks_on_deleted_at", using: :btree
  add_index "synset_interlinks", ["foreign_id"], name: "index_synset_interlinks_on_foreign_id", using: :btree
  add_index "synset_interlinks", ["revision"], name: "index_synset_interlinks_on_revision", using: :btree
  add_index "synset_interlinks", ["source"], name: "index_synset_interlinks_on_source", using: :btree
  add_index "synset_interlinks", ["synset_id"], name: "index_synset_interlinks_on_synset_id", using: :btree
  add_index "synset_interlinks", ["synset_interlink_id"], name: "index_synset_interlinks_on_synset_interlink_id", using: :btree
  add_index "synset_interlinks", ["updated_at"], name: "index_synset_interlinks_on_updated_at", using: :btree

  create_table "synset_relations", force: true do |t|
    t.integer  "synset_relation_id",             null: false
    t.integer  "synset1_id",                     null: false
    t.integer  "synset2_id",                     null: false
    t.integer  "author_id",                      null: false
    t.integer  "revision",           default: 1, null: false
    t.integer  "approver_id",                    null: false
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "synset_relations", ["approved_at"], name: "index_synset_relations_on_approved_at", using: :btree
  add_index "synset_relations", ["approver_id"], name: "index_synset_relations_on_approver_id", using: :btree
  add_index "synset_relations", ["author_id"], name: "index_synset_relations_on_author_id", using: :btree
  add_index "synset_relations", ["created_at"], name: "index_synset_relations_on_created_at", using: :btree
  add_index "synset_relations", ["deleted_at"], name: "index_synset_relations_on_deleted_at", using: :btree
  add_index "synset_relations", ["revision"], name: "index_synset_relations_on_revision", using: :btree
  add_index "synset_relations", ["synset1_id"], name: "index_synset_relations_on_synset1_id", using: :btree
  add_index "synset_relations", ["synset2_id"], name: "index_synset_relations_on_synset2_id", using: :btree
  add_index "synset_relations", ["synset_relation_id"], name: "index_synset_relations_on_synset_relation_id", using: :btree

  create_table "synset_words", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",        default: 1,  null: false
    t.integer  "word_id",                      null: false
    t.boolean  "nsg"
    t.integer  "examples_ids",    default: [],              array: true
    t.integer  "synset_word_id",               null: false
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.integer  "marks_ids",       default: [], null: false, array: true
    t.integer  "definitions_ids", default: [],              array: true
  end

  add_index "synset_words", ["approved_at"], name: "index_synset_words_on_approved_at", using: :btree
  add_index "synset_words", ["approver_id"], name: "index_synset_words_on_approver_id", using: :btree
  add_index "synset_words", ["author_id"], name: "index_synset_words_on_author_id", using: :btree
  add_index "synset_words", ["created_at"], name: "index_synset_words_on_created_at", using: :btree
  add_index "synset_words", ["definitions_ids"], name: "index_synset_words_on_definitions_ids", using: :gin
  add_index "synset_words", ["deleted_at"], name: "index_synset_words_on_deleted_at", using: :btree
  add_index "synset_words", ["examples_ids"], name: "index_synset_words_on_examples_ids", using: :gin
  add_index "synset_words", ["marks_ids"], name: "index_synset_words_on_marks_ids", using: :gin
  add_index "synset_words", ["nsg"], name: "index_synset_words_on_nsg", using: :btree
  add_index "synset_words", ["revision"], name: "index_synset_words_on_revision", using: :btree
  add_index "synset_words", ["synset_word_id"], name: "index_synset_words_on_synset_word_id", using: :btree
  add_index "synset_words", ["word_id"], name: "index_synset_words_on_word_id", using: :btree

  create_table "synsets", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.integer  "revision",               default: 1,  null: false
    t.datetime "deleted_at"
    t.integer  "synset_id"
    t.datetime "created_at"
    t.integer  "words_ids",              default: [],              array: true
    t.integer  "default_definition_id"
    t.integer  "default_synset_word_id"
  end

  add_index "synsets", ["approved_at"], name: "index_synsets_on_approved_at", using: :btree
  add_index "synsets", ["approver_id"], name: "index_synsets_on_approver_id", using: :btree
  add_index "synsets", ["author_id"], name: "index_synsets_on_author_id", using: :btree
  add_index "synsets", ["deleted_at"], name: "index_synsets_on_deleted_at", using: :btree
  add_index "synsets", ["revision"], name: "index_synsets_on_revision", using: :btree
  add_index "synsets", ["synset_id"], name: "index_synsets_on_synset_id", using: :btree
  add_index "synsets", ["words_ids"], name: "index_synsets_on_words_ids", using: :gin

  create_table "users", force: true do |t|
    t.string   "name",                   null: false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "role"
    t.integer  "sash_id"
    t.integer  "level",      default: 0
  end

  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

  create_table "word_relations", force: true do |t|
    t.integer  "word_relation_id",             null: false
    t.integer  "word1_id",                     null: false
    t.integer  "word2_id",                     null: false
    t.integer  "author_id",                    null: false
    t.integer  "revision",         default: 1, null: false
    t.integer  "approver_id",                  null: false
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "word_relations", ["approved_at"], name: "index_word_relations_on_approved_at", using: :btree
  add_index "word_relations", ["approver_id"], name: "index_word_relations_on_approver_id", using: :btree
  add_index "word_relations", ["author_id"], name: "index_word_relations_on_author_id", using: :btree
  add_index "word_relations", ["created_at"], name: "index_word_relations_on_created_at", using: :btree
  add_index "word_relations", ["deleted_at"], name: "index_word_relations_on_deleted_at", using: :btree
  add_index "word_relations", ["revision"], name: "index_word_relations_on_revision", using: :btree
  add_index "word_relations", ["word1_id"], name: "index_word_relations_on_word1_id", using: :btree
  add_index "word_relations", ["word2_id"], name: "index_word_relations_on_word2_id", using: :btree
  add_index "word_relations", ["word_relation_id"], name: "index_word_relations_on_word_relation_id", using: :btree

  create_table "words", force: true do |t|
    t.integer  "author_id"
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.datetime "created_at",                null: false
    t.integer  "revision",    default: 1,   null: false
    t.string   "word",                      null: false
    t.string   "grammar"
    t.datetime "deleted_at"
    t.integer  "word_id",                   null: false
    t.integer  "accents",     default: [],               array: true
    t.string   "uris",        default: [],               array: true
    t.float    "frequency",   default: 0.0, null: false
  end

  add_index "words", ["accents"], name: "index_words_on_accents", using: :btree
  add_index "words", ["approved_at"], name: "index_entries_on_approved_at", using: :btree
  add_index "words", ["approver_id"], name: "index_entries_on_approver_id", using: :btree
  add_index "words", ["author_id"], name: "index_entries_on_author_id", using: :btree
  add_index "words", ["deleted_at"], name: "index_entries_on_deleted_at", using: :btree
  add_index "words", ["frequency"], name: "index_words_on_frequency", using: :btree
  add_index "words", ["grammar"], name: "index_entries_on_grammar", using: :btree
  add_index "words", ["revision"], name: "index_entries_on_revision", using: :btree
  add_index "words", ["uris"], name: "index_words_on_uris", using: :btree
  add_index "words", ["word"], name: "index_words_on_word", using: :btree
  add_index "words", ["word_id"], name: "index_words_on_word_id", using: :btree

  add_foreign_key "antonomy_relations", "current_antonomy_relations", name: "antonomy_relations_antonomy_relation_id_fk", column: "antonomy_relation_id", dependent: :delete
  add_foreign_key "antonomy_relations", "current_synsets", name: "antonomy_relations_synset1_id_fk", column: "synset1_id", dependent: :delete
  add_foreign_key "antonomy_relations", "current_synsets", name: "antonomy_relations_synset2_id_fk", column: "synset2_id", dependent: :delete
  add_foreign_key "antonomy_relations", "current_words", name: "antonomy_relations_word1_id_fk", column: "word1_id", dependent: :delete
  add_foreign_key "antonomy_relations", "current_words", name: "antonomy_relations_word2_id_fk", column: "word2_id", dependent: :delete
  add_foreign_key "antonomy_relations", "users", name: "antonomy_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "antonomy_relations", "users", name: "antonomy_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_antonomy_relations", "current_synsets", name: "current_antonomy_relations_synset1_id_fk", column: "synset1_id", dependent: :delete
  add_foreign_key "current_antonomy_relations", "current_synsets", name: "current_antonomy_relations_synset2_id_fk", column: "synset2_id", dependent: :delete
  add_foreign_key "current_antonomy_relations", "current_words", name: "current_antonomy_relations_word1_id_fk", column: "word1_id", dependent: :delete
  add_foreign_key "current_antonomy_relations", "current_words", name: "current_antonomy_relations_word2_id_fk", column: "word2_id", dependent: :delete
  add_foreign_key "current_antonomy_relations", "users", name: "current_antonomy_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_antonomy_relations", "users", name: "current_antonomy_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_definitions", "users", name: "current_definitions_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_definitions", "users", name: "current_definitions_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_examples", "users", name: "current_examples_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_examples", "users", name: "current_examples_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_interlanguage_relations", "users", name: "current_interlanguage_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_interlanguage_relations", "users", name: "current_interlanguage_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_synset_interlinks", "current_synsets", name: "current_synset_interlinks_synset_id_fk", column: "synset_id", dependent: :delete
  add_foreign_key "current_synset_interlinks", "users", name: "current_synset_interlinks_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_synset_interlinks", "users", name: "current_synset_interlinks_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_synset_relations", "current_synsets", name: "current_synset_relations_synset1_id_fk", column: "synset1_id", dependent: :delete
  add_foreign_key "current_synset_relations", "current_synsets", name: "current_synset_relations_synset2_id_fk", column: "synset2_id", dependent: :delete
  add_foreign_key "current_synset_relations", "users", name: "current_synset_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_synset_relations", "users", name: "current_synset_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_synset_words", "current_words", name: "current_synset_words_word_id_fk", column: "word_id", dependent: :delete
  add_foreign_key "current_synset_words", "users", name: "current_synset_words_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_synset_words", "users", name: "current_synset_words_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_synsets", "current_definitions", name: "current_synsets_default_definition_id_fk", column: "default_definition_id"
  add_foreign_key "current_synsets", "current_synset_words", name: "current_synsets_default_synset_word_id_fk", column: "default_synset_word_id"
  add_foreign_key "current_synsets", "users", name: "current_synsets_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_synsets", "users", name: "current_synsets_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_word_relations", "current_words", name: "current_word_relations_word1_id_fk", column: "word1_id", dependent: :delete
  add_foreign_key "current_word_relations", "current_words", name: "current_word_relations_word2_id_fk", column: "word2_id", dependent: :delete
  add_foreign_key "current_word_relations", "users", name: "current_word_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_word_relations", "users", name: "current_word_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "current_words", "users", name: "current_words_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "current_words", "users", name: "current_words_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "definitions", "current_definitions", name: "definitions_definition_id_fk", column: "definition_id", dependent: :delete
  add_foreign_key "definitions", "users", name: "definitions_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "definitions", "users", name: "definitions_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "domains", "users", name: "domains_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "examples", "current_examples", name: "examples_example_id_fk", column: "example_id", dependent: :delete
  add_foreign_key "examples", "users", name: "examples_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "examples", "users", name: "examples_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "interlanguage_relations", "current_interlanguage_relations", name: "interlanguage_relations_interlanguage_relation_id_fk", column: "interlanguage_relation_id", dependent: :delete
  add_foreign_key "interlanguage_relations", "users", name: "interlanguage_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "interlanguage_relations", "users", name: "interlanguage_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "marks", "mark_categories", name: "marks_mark_category_id_fk", dependent: :delete

  add_foreign_key "posts", "users", name: "posts_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "raw_definitions", "current_definitions", name: "raw_definitions_definition_id_fk", column: "definition_id", dependent: :delete
  add_foreign_key "raw_definitions", "current_words", name: "raw_definitions_word_id_fk", column: "word_id", dependent: :delete
  add_foreign_key "raw_definitions", "users", name: "raw_definitions_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "raw_examples", "current_examples", name: "raw_examples_sample_id_fk", column: "example_id", dependent: :delete
  add_foreign_key "raw_examples", "raw_definitions", name: "raw_examples_raw_definition_id_fk", dependent: :delete
  add_foreign_key "raw_examples", "users", name: "raw_examples_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "raw_subsumptions", "current_words", name: "raw_subsumptions_hypernym_id_fk", column: "hypernym_id", dependent: :delete
  add_foreign_key "raw_subsumptions", "current_words", name: "raw_subsumptions_hyponym_id_fk", column: "hyponym_id", dependent: :delete

  add_foreign_key "raw_synonymies", "current_words", name: "raw_synonymies_word1_id_fk", column: "word1_id", dependent: :delete
  add_foreign_key "raw_synonymies", "current_words", name: "raw_synonymies_word2_id_fk", column: "word2_id", dependent: :delete
  add_foreign_key "raw_synonymies", "users", name: "raw_synonymies_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "raw_synset_words", "current_words", name: "raw_synset_words_word_id_fk", column: "word_id", dependent: :delete
  add_foreign_key "raw_synset_words", "users", name: "raw_synset_words_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "raw_synsets", "users", name: "raw_synsets_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "subsumption_answers", "raw_subsumptions", name: "subsumption_answers_raw_subsumption_id_fk", dependent: :delete
  add_foreign_key "subsumption_answers", "users", name: "subsumption_answers_user_id_fk", dependent: :delete

  add_foreign_key "synset_domains", "current_synsets", name: "synset_domains_synset_id_fk", column: "synset_id", dependent: :delete
  add_foreign_key "synset_domains", "domains", name: "synset_domains_domain_id_fk", dependent: :delete

  add_foreign_key "synset_interlinks", "current_synset_interlinks", name: "synset_interlinks_synset_interlink_id_fk", column: "synset_interlink_id", dependent: :delete
  add_foreign_key "synset_interlinks", "current_synsets", name: "synset_interlinks_synset_id_fk", column: "synset_id", dependent: :delete
  add_foreign_key "synset_interlinks", "users", name: "synset_interlinks_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "synset_interlinks", "users", name: "synset_interlinks_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "synset_relations", "current_synset_relations", name: "synset_relations_synset_relation_id_fk", column: "synset_relation_id", dependent: :delete
  add_foreign_key "synset_relations", "current_synsets", name: "synset_relations_synset1_id_fk", column: "synset1_id", dependent: :delete
  add_foreign_key "synset_relations", "current_synsets", name: "synset_relations_synset2_id_fk", column: "synset2_id", dependent: :delete
  add_foreign_key "synset_relations", "users", name: "synset_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "synset_relations", "users", name: "synset_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "synset_words", "current_synset_words", name: "synset_words_synset_word_id_fk", column: "synset_word_id", dependent: :delete
  add_foreign_key "synset_words", "current_words", name: "synset_words_word_id_fk", column: "word_id", dependent: :delete
  add_foreign_key "synset_words", "users", name: "synset_words_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "synset_words", "users", name: "synset_words_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "synsets", "current_synsets", name: "synsets_synset_id_fk", column: "synset_id", dependent: :delete
  add_foreign_key "synsets", "users", name: "synsets_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "synsets", "users", name: "synsets_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "word_relations", "current_word_relations", name: "word_relations_word_relation_id_fk", column: "word_relation_id", dependent: :delete
  add_foreign_key "word_relations", "current_words", name: "word_relations_word1_id_fk", column: "word1_id", dependent: :delete
  add_foreign_key "word_relations", "current_words", name: "word_relations_word2_id_fk", column: "word2_id", dependent: :delete
  add_foreign_key "word_relations", "users", name: "word_relations_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "word_relations", "users", name: "word_relations_author_id_fk", column: "author_id", dependent: :delete

  add_foreign_key "words", "current_words", name: "words_word_id_fk", column: "word_id", dependent: :delete
  add_foreign_key "words", "users", name: "entries_approver_id_fk", column: "approver_id", dependent: :delete
  add_foreign_key "words", "users", name: "entries_author_id_fk", column: "author_id", dependent: :delete

end
