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

ActiveRecord::Schema.define(:version => 20110416143119) do

  create_table "authors", :id => false, :force => true do |t|
    t.string   "id",         :limit => nil
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :id => false, :force => true do |t|
    t.string   "id",                   :limit => nil
    t.string   "parent_id",            :limit => nil
    t.string   "author_id",            :limit => nil
    t.string   "rincex_project_id"
    t.string   "rincex_dir_id"
    t.string   "rincex_publishing_id"
    t.string   "rincex_file_id"
    t.date     "rincex_date"
    t.string   "item_type"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.datetime "last_scraped"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
