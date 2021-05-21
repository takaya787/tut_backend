class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # belongs_toで設定されるcolumnの値は自動的にvalidationが設定される
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
