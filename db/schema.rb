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

ActiveRecord::Schema.define(:version => 20140916201932) do

  create_table "agreements", :force => true do |t|
    t.boolean  "agree"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.boolean  "agreement_boolean"
    t.string   "price"
    t.text     "description"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "negotiation_id"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "negotiations", :force => true do |t|
    t.string   "secure_key"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "scenario_id"
    t.integer  "first_user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "agreement_time"
    t.integer  "second_user_id"
  end

  add_index "negotiations", ["secure_key"], :name => "index_negotiations_on_secure_key", :unique => true

  create_table "scenarios", :force => true do |t|
    t.text     "general"
    t.text     "first_role"
    t.text     "second_role"
    t.string   "title"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "language"
    t.string   "first_role_title"
    t.string   "second_role_title"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "sex"
    t.string   "secure_key"
    t.text     "native_languages"
    t.text     "foreign_languages"
    t.boolean  "admin",             :default => false
    t.boolean  "consent",           :default => false
    t.boolean  "background",        :default => false
    t.datetime "start_background"
    t.datetime "end_background"
    t.date     "date_of_birth"
    t.string   "country"
    t.integer  "start_english"
    t.boolean  "english_home"
    t.text     "acquired_english"
    t.integer  "hebrew_listening"
    t.integer  "hebrew_speaking"
    t.integer  "hebrew_reading"
    t.integer  "hebrew_writing"
    t.integer  "english_listening"
    t.integer  "english_speaking"
    t.integer  "english_reading"
    t.integer  "english_writing"
    t.text     "emotions"
    t.text     "research"
    t.integer  "subject_number"
    t.string   "chosen_goals"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token", :unique => true

end
