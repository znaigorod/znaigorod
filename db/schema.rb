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

ActiveRecord::Schema.define(:version => 20120625023033) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "house"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "addresses", ["organization_id"], :name => "index_addresses_on_organization_id"

  create_table "affiche_schedules", :force => true do |t|
    t.integer  "affiche_id"
    t.date     "starts_on"
    t.date     "ends_on"
    t.time     "starts_at"
    t.time     "ends_at"
    t.string   "holidays"
    t.string   "place"
    t.string   "hall"
    t.integer  "price_min"
    t.integer  "price_max"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "affiche_schedules", ["affiche_id"], :name => "index_affiche_schedules_on_affiche_id"

  create_table "affiches", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "description"
    t.string   "original_title"
    t.string   "poster_url"
    t.text     "trailer_code"
    t.string   "type"
    t.text     "tag"
    t.string   "vfs_path"
    t.string   "image_url"
  end

  create_table "halls", :force => true do |t|
    t.string   "title"
    t.integer  "seating_capacity"
    t.integer  "organization_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "halls", ["organization_id"], :name => "index_halls_on_organization_id"

  create_table "images", :force => true do |t|
    t.text     "url"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
  end

  add_index "images", ["organization_id"], :name => "index_images_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.text     "title"
    t.text     "categories"
    t.text     "payment"
    t.text     "cuisine"
    t.text     "feature"
    t.text     "site"
    t.text     "email"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "phone"
    t.text     "offer"
    t.string   "type"
    t.string   "vfs_path"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "day"
    t.time     "from"
    t.time     "to"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "holiday"
  end

  create_table "showings", :force => true do |t|
    t.integer  "affiche_id"
    t.string   "place"
    t.datetime "starts_at"
    t.integer  "price_min"
    t.string   "hall"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "ends_at"
    t.integer  "price_max"
    t.integer  "organization_id"
  end

  add_index "showings", ["affiche_id"], :name => "index_showings_on_affiche_id"

end
