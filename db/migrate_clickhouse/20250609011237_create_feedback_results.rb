class CreateFeedbackResults < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE TABLE feedback_results
      (
        id UUID,
        feedback_id UUID,
        estimated_affected_accounts UInt32,
        affected_devices UInt32,
        processed_time DateTime,
        created_at DateTime,
        updated_at DateTime
      )
      ENGINE = MergeTree
      PARTITION BY toYYYYMM(processed_time)
      ORDER BY (feedback_id, processed_time)
      SETTINGS index_granularity = 8192
    SQL
  end

  def down
    execute <<~SQL
      DROP TABLE feedback_results
    SQL
  end
end
