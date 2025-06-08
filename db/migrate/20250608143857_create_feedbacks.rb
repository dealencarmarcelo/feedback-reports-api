class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks, id: :uuid do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true

      t.references :reported_by_user, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.uuid :account_id, null: false
      t.uuid :installation_id, null: false
      t.string :encoded_installation_id, null: false
      t.string :feedback_type, null: false
      t.datetime :feedback_time, null: false

      t.timestamps
    end
  end
end
