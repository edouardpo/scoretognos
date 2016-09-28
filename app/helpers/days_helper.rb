module DaysHelper
  def bet_elements bet
    elements = []
    elements << (bet.result == "draw" ? "Draw" : "Winner: #{bet.winner.name}")

    unless bet.result == "draw"
      pg = bet.points_gap
      elements << "Points gap: #{pg.bottom}#{pg.top ? "-#{pg.top}" : "+"}"
    end

    if bet.bonus_off
      team_bonus_off = if (bet.bonus_off == "a")
        bet.fixture.team_a
      else
        bet.fixture.team_b
      end
      elements << "Bonus off: #{team_bonus_off.name}"
    end

    if bet.bonus_def
      team_bonus_def = if (bet.bonus_def == "a")
        bet.fixture.team_a
      else
        bet.fixture.team_b
      end
      elements << "Bonus def: #{team_bonus_def.name}"
    end

    elements.join(", ")
  end

  def display_result fixture, team_type
    score = ( team_type == "a" ? fixture.score_a : fixture.score_b)
    team = ( team_type == "a" ? fixture.team_a : fixture.team_b)
    "#{score} #{team.name}"
  end

  def display_bonus fixture, team_type
    bonus_def = true if ( fixture.bonus_def == team_type )
    bonus_off = true if ( fixture.bonus_off == team_type )

    if bonus_def || bonus_off
      bonus = []
      bonus << "Off" if bonus_off
      bonus << "Def" if bonus_def
      return "#{(bonus.join(", "))}"
    end
  end
end
