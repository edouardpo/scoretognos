class Fixture < ActiveRecord::Base
  obfuscate_id

  belongs_to :day
  belongs_to :team_a, class_name: 'Team'
  belongs_to :team_b, class_name: 'Team'
  has_many :bets

  before_validation :set_dates
  before_validation :set_bonus
  validates :day, :team_a, :team_b, :starts_at, :bets_start_at, :bets_end_at, presence: :true

  after_save :update_bets, if: Proc.new { |f| f.score_a_changed? || f.score_b_changed? || bonus_off_changed? || bonus_def_changed? }

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
        Result::DRAW
      end
    else
      Result::UNKNOWN
    end
  end

  def points_gap
    (score_a - score_b).abs
  end

  def winner
    if result == Result::A
      team_a
    elsif result == Result::B
      team_b
    end
  end

  def score_registered?
    !!score_a && !!score_b
  end

  def bettable?
    now = Time.now
    ( now >= bets_start_at ) && ( now <= bets_end_at )
  end

  def bets_closed?
    Time.now > bets_end_at
  end

  def bet user_score
    bets.where(user_score: user_score).first
  end

  def self.bettable
    now = Time.now
    self.where("bets_start_at <= ? AND bets_end_at >= ?", now, now).order(bets_end_at: :desc)
  end

  def self.passed
    self.where("starts_at <= ?", Time.now - 2.hours)
  end

  def self.to_come
    self.where("starts_at > ?", Time.now - 2.hours)
  end

  def self.to_update
    self.passed.where(score_a: nil)
  end

  private

  def set_bonus
    self.bonus_def = nil if bonus_def.blank?
    self.bonus_off = nil if bonus_off.blank?
  end

  def set_dates
    if day
      self.starts_at = day.date unless !!self.starts_at
      self.bets_start_at = self.starts_at.beginning_of_week(start_day = :monday) unless !!self.bets_start_at
      self.bets_end_at = self.starts_at.beginning_of_day
    end
  end

  def update_bets
    bets.all.each { |b| b.update_points }
  end
end
