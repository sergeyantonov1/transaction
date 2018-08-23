class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :received_amounts, foreign_key: :user_to_id, class_name: "Transaction"
  has_many :sent_amounts, foreign_key: :user_from_id, class_name: "Transaction"

  validates :full_name, presence: true
end
