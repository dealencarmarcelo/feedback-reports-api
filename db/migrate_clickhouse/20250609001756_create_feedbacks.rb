class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE TABLE feedbacks
      (
        id UUID,
        organization_id UUID,
        account_id UUID,
        installation_id UUID,
        encoded_installation_id String,
        reported_by_user_id UUID,
        feedback_type String,
        feedback_time DateTime,
        created_at DateTime,
        updated_at DateTime
      )
      ENGINE = MergeTree
      PARTITION BY toYYYYMM(feedback_time)
      ORDER BY (organization_id, feedback_time)
      SETTINGS index_granularity = 8192
    SQL
  end

  def down
    execute <<~SQL
      DROP TABLE feedbacks
    SQL
  end
end
