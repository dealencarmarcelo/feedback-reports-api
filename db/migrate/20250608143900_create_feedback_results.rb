class CreateFeedbackResults < ActiveRecord::Migration[7.0]
  def change
    create_table :feedback_results, id: :uuid do |t|
      t.references :feedback, null: false, foreign_key: true
      t.integer :affected_devices, null: false, default: 0
      t.integer :estimated_affected_accounts, null: false, default: 0
      t.datetime :processed_time, null: false

      t.timestamps
    end

    add_index :feedback_results, :processed_time
    add_index :feedback_results, [ :feedback_id, :processed_time ]
  end
end
