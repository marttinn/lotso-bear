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

ActiveRecord::Schema.define(version: 20140823192216) do

  create_table "car_statuses", force: true do |t|
    t.string   "carStatus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cars", force: true do |t|
    t.integer  "genericCar_id"
    t.integer  "insured_id"
    t.integer  "warehouse_id"
    t.string   "carColor"
    t.integer  "carDoorNumber"
    t.string   "carSerie"
    t.string   "carMotor"
    t.string   "carLicensePlates"
    t.text     "carInventoryDescription"
    t.string   "carTaxiNumber"
    t.text     "carSpecialEquipment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generic_cars", force: true do |t|
    t.string   "genericCarBrand"
    t.string   "genericCarType"
    t.integer  "genericCarYear"
    t.string   "genericCarGeneration"
    t.string   "genericCarModel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insureds", force: true do |t|
    t.integer  "sinister_id"
    t.boolean  "insuredIsThird"
    t.string   "insuredName"
    t.integer  "insuredTelephone"
    t.string   "insuredMail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pre_valuations", force: true do |t|
    t.integer  "insured_id"
    t.string   "preValuationNumber"
    t.string   "preValuationPolicyNumber"
    t.string   "preValuationSubsection"
    t.date     "preValuationExpeditionDate"
    t.date     "preValuationDate"
    t.float    "preValuationDeductibleValue"
    t.float    "preValuationCommercialValue"
    t.boolean  "preValuationRequiresCrane"
    t.boolean  "preValuationCollectionStatus"
    t.string   "preValuationSpecialConditions"
    t.boolean  "preValuationThirdInsured"
    t.string   "preValuationAgentName"
    t.text     "preValuationComment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_brands", force: true do |t|
    t.string   "sparePartBrandName"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_groups", force: true do |t|
    t.text     "sparePartGroupDescription"
    t.string   "sparePartGroupName"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_statuses", force: true do |t|
    t.string   "sparePartStatus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_types", force: true do |t|
    t.string   "sparePartTypeName"
    t.text     "sparePartTypeDescription"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_parts", force: true do |t|
    t.integer  "car_id"
    t.integer  "wareHouse_id"
    t.integer  "genericCar_id"
    t.integer  "sparePartGroup_id"
    t.integer  "sparePartBrand"
    t.integer  "sparePartType"
    t.integer  "sparePartStatus"
    t.string   "sparePartName"
    t.text     "sparePartDescription"
    t.string   "sparePartCarRegion"
    t.string   "sparePartCode"
    t.string   "sparePartColor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "privileges"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "warehouses", force: true do |t|
    t.string   "warehouseBranch"
    t.string   "warehouseLocation"
    t.string   "warehouseGeolocation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
