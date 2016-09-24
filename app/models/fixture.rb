class Fixture < ActiveRecord::Base
  obfuscate_id

  belongs_to :day
  belongs_to :team_a, class_name: 'Team'
  belongs_to :team_b, class_name: 'Team'

  before_validation :set_dates
  validates :day, :team_a, :team_b, :starts_at, :bets_start_at, :bets_end_at, presence: :true

  after_save :update_all_bets, if: Proc.new { |f| f.score_a_changed? || f.score_b_changed? || bonus_off_changed? || bonus_def_changed? }

  module BonusOff
    A = 'a'
    B = 'b'
    ALL = [A, B]
  end

  module BonusDef
    A = 'a'
    B = 'b'
    ALL = [A, B]
  end

  validates :bonus_off, inclusion: { in: [BonusOff::ALL, nil].flatten  }
  validates :bonus_def, inclusion: { in: [BonusDef::ALL, nil].flatten  }

  module Result
    A = 'a'
    B = 'b'
    DRAW = 'draw'
    UNKNOWN = 'unkonwn'
  end

  def result
    if !!score_a && !!score_b
      if score_a > score_b
        Result::A
      elsif score_a < score_b
        Result::B
      else
        Result::Draw
      end
    else
      Result::Draw
    end
  end

  def points_gap
    (score_a - score_b).abs
  end

  private

  def set_dates
    if day
      self.starts_at = day.date unless !!self.starts_at
      self.bets_start_at = day.date.beginning_of_week(start_day = :monday) unless !!self.bets_start_at
      self.bets_end_at = day.date - 1.days unless !!self.bets_end_at
    end
  end

  def update_all_bets
    bets.all.each {|b| b.update_points}
  end
end
