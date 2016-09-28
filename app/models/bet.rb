class Bet < ActiveRecord::Base
  obfuscate_id

  belongs_to :user_score
  belongs_to :fixture
  belongs_to :points_gap

  validates :user_score, :fixture, :result, presence: :true
  after_save :update_user_score, on: :update

  RESULT = %w(a b draw)

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

  before_validation :set_bonus

  validates :result, inclusion: { in: RESULT }
  validates :bonus_off, inclusion: { in: [BonusOff::ALL, nil].flatten }
  validates :bonus_def, inclusion: { in: [BonusDef::ALL, nil].flatten }
  validate :valid_points_gap, :valid_bonus_def
  validates :fixture, uniqueness: { scope: :user_score_id,
    message: "You can place only one bet on a fixture." }
  validate :fixture_bettable


  def update_points
    total_points = 0

    # Result
    if result == fixture.result
      if fixture.result == Fixture::Result::DRAW
        total_points += 25
      else
        total_points += 3
        # Points gap
        if points_gap
          actual_points_gap = fixture.points_gap
          if ( actual_points_gap >= points_gap.bottom )
            total_points += 5 if ( !points_gap.top || (actual_points_gap <= points_gap.top) )
          end
        end

        # Bonus
        if !!fixture.bonus_off
          total_points += 2 if bonus_off == fixture.bonus_off
        else
          total_points += 1 if bonus_off.nil?
        end

        if !!fixture.bonus_def
          total_points += 2 if bonus_def == fixture.bonus_def
        else
          total_points += 1 if bonus_def.nil?
        end
      end
    end

    if fixture.day.status == Day::Status::FINALS
      total_points = total_points * 2
    end

    self.points = total_points
    self.save!(validate: false)
  end

  def user
    user_score.user
  end

  def winner
    if result == "a"
      fixture.team_a
    elsif result == "b"
      fixture.team_b
    end
  end

  def self.fixtures
    self.all.map(&:fixture)
  end

  private

  def set_bonus
    self.bonus_def = nil if bonus_def.blank?
    self.bonus_off = nil if bonus_off.blank?
  end

  def update_user_score
    new_user_score_value = 0
    user_score.bets.all.each {|b| new_user_score_value += b.points.to_i }
    user_score.update(value: new_user_score_value)
  end

  def fixture_bettable
    errors.add(:fixture, "Bets on this fixture are not open.") unless fixture.bettable?
  end

  def valid_points_gap
    if result == "draw"
      errors.add(:points_gap, "there should be no points gap") if !!points_gap
    else
      errors.add(:points_gap, "there should be a points gap") if !points_gap
    end
  end

  def valid_bonus_def
    errors.add(:bonus_def, "Bonus def can only be awarded to looser.") if (result == "draw" && !!bonus_def) || (result == bonus_def)
  end
end
