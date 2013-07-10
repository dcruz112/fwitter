class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: "User"
  validates :user_id, presence: true
  validates :creator_id, presence: true
end
