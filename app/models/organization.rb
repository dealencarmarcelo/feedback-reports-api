class Organization < ApplicationRecord
  establish_connection :primary
  self.table_name = "organizations"

  has_many :feedbacks, dependent: :destroy
  has_many :feedback_results, through: :feedbacks
  has_many :users, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  def total_feedbacks_count
    feedbacks.count
  end

  def processed_feedbacks_count
    feedbacks.joins(:feedback_result).count
  end
end
