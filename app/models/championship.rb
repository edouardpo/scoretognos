class Championship < ActiveRecord::Base
  obfuscate_id

  has_many :teams
  has_many :days
  has_many :user_scores

  validates :name, :start_date, :end_date, presence: :true
  validate :ends_after_starts

  private

  def ends_after_starts
    errors.add(:end_date, "Must ends after starts") unless end_date > start_date
  end
end
