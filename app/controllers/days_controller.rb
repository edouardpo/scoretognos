class DaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_day
  before_action :set_championship
  before_action :set_user_score
  before_action :set_days
  before_action :set_fixtures

  def show
    unless @user.has_joined(@championship)
      flash[:alert] = "You must follow this chamionship to access it !"
      redirect_to championships_path
    end
  end

  private

  def set_day
    @day = Day.find(params[:id])
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
