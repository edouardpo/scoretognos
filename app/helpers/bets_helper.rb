module BetsHelper
  def bet_result_options_for_select(fixture)
    [
      ['Draw', "draw"],
      [fixture.team_a.name, "a"],
      [fixture.team_b.name, "b"],
    ]
  end

  def bet_points_gap_options_for_select
    options = [["-", nil]]
    PointsGap.active.order(:bottom).all.each do |pg|
      interval = "#{pg.bottom}"
      interval << ( pg.top.nil? ? "+" : "-#{pg.top}" )
      options << [interval, pg.id]
    end
    options
  end

  def bet_bonus_options_for_select(fixture)
    [
      ['-', nil],
      [fixture.team_a.name, "a"],
      [fixture.team_b.name, "b"],
    ]
  end
end
