class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :championship
  has_many :bets
end
