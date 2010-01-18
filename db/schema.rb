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

ActiveRecord::Schema.define(:version => 20100118222757) do

  create_table "building_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "effect"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bonus_type"
    t.integer  "cost"
    t.string   "words_required"
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
    t.integer  "knowledge_chance"
    t.integer  "correct_tests"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "incorrect_tests"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "energy"
    t.integer  "food"
    t.string   "authentication"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "villages", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "population",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ration_level", :default => "normal"
  end

  create_table "words", :force => true do |t|
    t.string   "english"
    t.string   "pinyin"
    t.string   "character"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end