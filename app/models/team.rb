class Team < ActiveRecord::Base
  obfuscate_id

  belongs_to :championship
  has_many :fixtures_a, class_name: 'Fixture', foreign_key: 'team_a_id'
  has_many :fixtures_b, class_name: 'Fixture', foreign_key: 'team_b_id'
end
