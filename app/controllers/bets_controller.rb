class BetsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :get_fixtures_to_bet
  before_action :set_fixture
  before_action :set_day
  before_action :set_championship
  before_action :set_user_score

  def create
    @bet = Bet.new(bet_params)
    @bet.user_score = @user_score

    if @bet.save
      get_fixtures_to_bet
    else
      flash.now[:alert] = "Bet is invalid"
    end

    set_days
    set_fixtures

    respond_to do |format|
      format.html { render "days/show" }
      format.js { render "days/bets" }
    end
  end

  def update
    @bet = @user_score.bets.find_by(fixture_id: @fixture.id)
    @bet.attributes = bet_params

    if @bet.save
      get_fixtures_to_bet
    else
      flash.now[:alert] = "Bet is invalid"
    end

    set_days
    set_fixtures

    respond_to do |format|
      format.html { render "days/show" }
      format.js { render "days/bets" }
    end
  end

  private

  def bet_params
    params.require(:bet).permit(:fixture_id, :result, :points_gap_id, :bonus_off, :bonus_def)
  end

  def set_bet
    @bet = Bet.new(bet_params)
  end

  def set_fixture
    @fixture = Fixture.find_by(id: params[:bet][:fixture_id])
  end

  def set_day
    @day = @fixture.day
  end

  def set_championship
    @championship = @day.championship
  end

  def set_user_score
    @user_score = @user.user_scores.where(championship: @championship).first
  end

  def set_days
    @days = @championship.days.order(date: :asc)
  end

  def set_fixtures
    @fixtures = @day.fixtures
  end
end
