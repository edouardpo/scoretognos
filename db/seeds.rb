# CHAMPIONSHIP
championship = Championship.create!(
  name: "FFSE Rugby 2016/2017",
  start_date: Date.new(2016,9,1),
  end_date: Date.new(2017,6,30)
)

# Teams
14.times do
  championship.teams.create(name: Faker::Team.name)
end

# Days
i = 0
10.times do
  day = championship.days.create!(
    date: championship.start_date + (7*i).days,
    status: Day::Status::REGULAR,
    name: "J#{i+1}"
  )

  i += 1

  available_teams = []
  championship.teams.all.each {|t| available_teams << t}
  available_teams.shuffle!

  # Fixtures
  7.times do
    team_a = available_teams.first
    team_b = available_teams.last
    day.fixtures.create!(
      team_a: team_a,
      team_b: team_b
    )
    available_teams.delete(team_a)
    available_teams.delete(team_b)
  end
end

#Points Gap
PointsGap.create(bottom: 1, top: 6)
PointsGap.create(bottom: 7, top: 10)
PointsGap.create(bottom: 11, top: 15)
PointsGap.create(bottom: 16, top: 20)
PointsGap.create(bottom: 21, top: 30)
PointsGap.create(bottom: 31, top: 40)
PointsGap.create(bottom: 41, top: 50)
PointsGap.create(bottom: 50)

