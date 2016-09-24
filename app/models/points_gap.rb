class PointsGap < ActiveRecord::Base
  has_many :bets
  validates :bottom, presence: :true
end
