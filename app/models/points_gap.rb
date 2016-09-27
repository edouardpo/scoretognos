class PointsGap < ActiveRecord::Base
  has_many :bets
  validates :bottom, presence: :true

  def self.active
    where(active: true)
  end
end
