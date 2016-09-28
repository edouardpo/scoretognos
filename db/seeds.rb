AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

#Points Gap
PointsGap.create(bottom: 1, top: 5, active: true)
PointsGap.create(bottom: 6, top: 15, active: true)
PointsGap.create(bottom: 16, top: 25, active: true)
PointsGap.create(bottom: 26, top: 40, active: true)
PointsGap.create(bottom: 41, active: true)

# CHAMPIONSHIP
championship = Championship.create!(
  name: "FFSE Rugby 2016/2017",
  start_date: Date.new(2016,9,3),
  end_date: Date.new(2017,6,30)
)

if Rails.env.development?
  today = Date.today

  # Teams
  14.times do
    championship.teams.create(name: Faker::Team.name)
  end

  #Players
  27.times do
    user = User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: Faker::Internet.password(8),
      facebook_picture_url: "https://graph.facebook.com/v2.6/10153713948506326/picture?type=square"
    )
    user.user_scores.create!(championship: championship)
  end

  # Days
  i = 0
  10.times do
    day = championship.days.create!(
      date: championship.start_date + (7*i).days + 15.hours,
      status: Day::Status::REGULAR,
      name: "Day #{i+1}"
    )

    i += 1

    available_teams = []
    championship.teams.all.each {|t| available_teams << t}
    available_teams.shuffle!

    # Fixtures
    7.times do
      team_a = available_teams.first
      team_b = available_teams.last
      f = day.fixtures.create!(
        team_a: team_a,
        team_b: team_b
      )
      available_teams.delete(team_a)
      available_teams.delete(team_b)

      if f.starts_at < today
        championship.user_scores.all.each do |us|
          b = Bet.new(
            user_score: us,
            fixture: f,
            result: %w(a b draw).shuffle.first
          )
          unless b.result == "draw"
            b.points_gap = PointsGap.all.shuffle.first
            b.bonus_off = [b.result, nil].shuffle.first
            b.bonus_def = [(b.result == "a" ? "b" : "a"), nil].shuffle.first
          end
          b.save!(validate: false)
        end

        f.score_a = Random.rand(20)
        f.score_b = Random.rand(20)

        if f.score_a > f.score_b
          f.bonus_off = ["a", nil].shuffle.first
          f.bonus_def = ["b", nil].shuffle.first
        elsif f.score_a < f.score_b
          f.bonus_off = ["b", nil].shuffle.first
          f.bonus_def = ["a", nil].shuffle.first
        end
        f.save!
      end

    end
  end
end


