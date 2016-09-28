ActiveAdmin.register Fixture do
  scope :to_update
  scope :passed
  scope :to_come
  actions :index, :new, :create, :edit, :update
  permit_params :day_id, :team_a_id, :team_b_id, :score_a, :score_b,
    :bonus_off, :bonus_def, :starts_at, :bets_start_at, :bets_end_at

  index do
    column "Id", :to_param
    column :team_a
    column :team_b
    column :score_a
    column :score_b
    column :bonus_off
    column :bonus_def
    column :starts_at
    column :bets_start_at
    column :bets_end_at
    column :updated_at
    actions
  end
end
