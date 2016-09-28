class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :championship
  has_many :bets

  validates :championship, uniqueness: { scope: :user_id,
    message: "You already joined this championship." }
end
