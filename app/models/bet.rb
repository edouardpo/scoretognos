class Bet < ActiveRecord::Base
  belongs_to :user_score
  belongs_to :fixture
  belongs_to :points_gap

  validates :user_score, :fixture, :points_gap, :result, presence: :true
  after_save :update_user_score, on: :update

  RESULT = %w(a b draw)
  BONUSOFF = %w(a b)
  BONUSDEF = %w(a b)

  validates :result, inclusion: { in: RESULT }
  validates :bonus_off, inclusion: { in: BONUSOFF }
  validates :bonus_def, inclusion: { in: BONUSDEF }


  def update_points
    total_points = 0

    # Result
    if result == fixture.result
      total_points += 3

      # Points gap
      unless fixture.result == Fixture::Result::DRAW
        actual_points_gap = fixture.points_gap
        if ( actual_points_gap >= points_gap.bottom )
          total_points += 5 if ( !points.gap_top || (actual_points_gap <= points_gap.top) )
        end
      end
    end

    # Bonus
    total_points += 1 if bonus_off == fixture.bonus_off
    total_points += 1 if bonus_def == fixture.bonus_def

    if fixture.day.status == Day::Status::FINALS
      total_points = total_points * 2
    end

    self.points = total_points
    self.save!
  end

  private

  def update_user_score
    new_user_score_value = 0
    user_score.bets.all.each {|b| new_user_score_value += b.points.to_i }
    user_score.update(value: new_user_score_value)
  end

end
