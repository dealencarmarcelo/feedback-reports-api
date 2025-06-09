class User < ApplicationRecord
  establish_connection :primary
  self.table_name = "users"

  belongs_to :organization
  has_many :feedbacks, foreign_key: "reported_by_user_id", primary_key: "id"

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_insensitive: true }
end
