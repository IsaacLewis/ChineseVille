# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100205205018) do

  create_table "building_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "effect"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bonus_type"
    t.integer  "cost"
    t.integer  "words_required",     :limit => 255
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
  end

  create_table "buildings", :force => true do |t|
    t.integer  "village_id"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  create_table "flashcard_tests", :force => true do |t|
    t.integer  "flashcard_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flashcards", :force => true do |t|
    t.integer  "word_id"
    t.integer  "user_id"
    t.integer  "knowledge_chance", :default => 0
    t.integer  "correct_tests",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "incorrect_tests",  :default => 0
    t.datetime "next_due"
    t.decimal  "efactor",          :default => 2.5
    t.decimal  "last_interval"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "energy",          :default => 20
    t.integer  "food",            :default => 0
    t.string   "authentication"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_list_id"
    t.integer  "facebook_id"
    t.integer  "combos",          :default => 0
  end

  create_table "villages", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "population",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ration_level", :default => "normal"
  end

  create_table "word_lists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.string   "english"
    t.string   "pinyin"
    t.string   "character"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "word_list_id"
    t.integer  "position"
  end

end
