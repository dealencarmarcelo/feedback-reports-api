# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_09_011237) do
  # TABLE: feedback_results
  # SQL: CREATE TABLE feedback_results ( `id` UUID, `feedback_id` UUID, `estimated_affected_accounts` UInt32, `affected_devices` UInt32, `processed_time` DateTime, `created_at` DateTime, `updated_at` DateTime ) ENGINE = MergeTree PARTITION BY toYYYYMM(processed_time) ORDER BY (feedback_id, processed_time) SETTINGS index_granularity = 8192
  create_table "feedback_results", id: :uuid, options: "MergeTree PARTITION BY toYYYYMM(processed_time) ORDER BY (feedback_id, processed_time) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.uuid "id", null: false
    t.uuid "feedback_id", null: false
    t.integer "estimated_affected_accounts", null: false
    t.integer "affected_devices", null: false
    t.datetime "processed_time", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  # TABLE: feedbacks
  # SQL: CREATE TABLE feedbacks ( `id` UUID, `organization_id` UUID, `account_id` UUID, `installation_id` UUID, `encoded_installation_id` String, `reported_by_user_id` UUID, `feedback_type` String, `feedback_time` DateTime, `created_at` DateTime, `updated_at` DateTime ) ENGINE = MergeTree PARTITION BY toYYYYMM(feedback_time) ORDER BY (organization_id, feedback_time) SETTINGS index_granularity = 8192
  create_table "feedbacks", id: :uuid, options: "MergeTree PARTITION BY toYYYYMM(feedback_time) ORDER BY (organization_id, feedback_time) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.uuid "id", null: false
    t.uuid "organization_id", null: false
    t.uuid "account_id", null: false
    t.uuid "installation_id", null: false
    t.string "encoded_installation_id", null: false
    t.uuid "reported_by_user_id", null: false
    t.string "feedback_type", null: false
    t.datetime "feedback_time", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

end
